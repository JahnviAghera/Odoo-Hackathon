import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY');
const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req) => {
  const { userId, code } = await req.json();

  // Check if the code exists and is not used
  const { data: codeData, error: codeError } = await supabase
    .from('redeem_codes')
    .select('id, points, is_used')
    .eq('code', code)
    .single();

  if (codeError || !codeData) {
    return new Response(JSON.stringify({ error: 'Invalid or expired code' }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    });
  }

  if (codeData.is_used) {
    return new Response(JSON.stringify({ error: 'This code has already been used' }), {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    });
  }

  // Award points and mark the code as used in a transaction
  const { error: transactionError } = await supabase.rpc('redeem_code', {
    user_id_param: userId,
    code_id_param: codeData.id,
    points_to_add: codeData.points,
  });

  if (transactionError) {
    return new Response(JSON.stringify({ error: transactionError.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }

  return new Response(JSON.stringify({ success: true, points: codeData.points }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
