-- REDEEM CODES TABLE
CREATE TABLE redeem_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT UNIQUE NOT NULL,
    points INT NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    used_by UUID REFERENCES user_rewear(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

-- Stored procedure for redeeming a code
CREATE OR REPLACE FUNCTION redeem_code(user_id_param UUID, code_id_param UUID, points_to_add INT)
RETURNS VOID AS $
BEGIN
  -- Add points to the user
  UPDATE user_rewear
  SET points = points + points_to_add
  WHERE id = user_id_param;

  -- Mark the code as used
  UPDATE redeem_codes
  SET is_used = TRUE, used_by = user_id_param
  WHERE id = code_id_param;
END;
$ LANGUAGE plpgsql;
