import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY');
const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req) => {
  const { userId, rewardId } = await req.json();

  // Get user points and reward cost in a single query
  const { data, error } = await Promise.all([
    supabase.from('user_rewear').select('points').eq('id', userId).single(),
    supabase.from('rewards').select('points_cost').eq('id', rewardId).single(),
  ]);

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }

  const userPoints = data[0].data.points;
  const rewardCost = data[1].data.points_cost;

  if (userPoints < rewardCost) {
    return new Response(JSON.stringify({ error: 'Not enough points' }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    });
  }

  const newPoints = userPoints - rewardCost;

  // Perform the redemption in a transaction
  const { error: transactionError } = await supabase.rpc('redeem_reward', {
    user_id: userId,
    reward_id: rewardId,
    points_to_deduct: rewardCost,
  });


  if (transactionError) {
    return new Response(JSON.stringify({ error: transactionError.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
