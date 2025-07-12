-- REWARDS TABLE
CREATE TABLE rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    points_cost INT NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USER REWARDS TABLE
CREATE TABLE user_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES user_rewear(id) ON DELETE CASCADE,
    reward_id UUID REFERENCES rewards(id) ON DELETE CASCADE,
    redeemed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stored procedure for redeeming a reward
CREATE OR REPLACE FUNCTION redeem_reward(user_id_param UUID, reward_id_param UUID, points_to_deduct INT)
RETURNS VOID AS $
BEGIN
  -- Deduct points from the user
  UPDATE user_rewear
  SET points = points - points_to_deduct
  WHERE id = user_id_param;

  -- Insert a record into the user_rewards table
  INSERT INTO user_rewards (user_id, reward_id)
  VALUES (user_id_param, reward_id_param);
END;
$ LANGUAGE plpgsql;
