import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL');
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY');
const supabase = createClient(supabaseUrl, supabaseKey);

Deno.serve(async (req) => {
  const { userId, points } = await req.json();

  const { data: user, error: fetchError } = await supabase
    .from('user_rewear')
    .select('points')
    .eq('id', userId)
    .single();

  if (fetchError) {
    return new Response(JSON.stringify({ error: fetchError.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }

  const newPoints = (user.points || 0) + points;

  const { error: updateError } = await supabase
    .from('user_rewear')
    .update({ points: newPoints })
    .eq('id', userId);

  if (updateError) {
    return new Response(JSON.stringify({ error: updateError.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
