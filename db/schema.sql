-- USERS TABLE
CREATE TABLE user_rewear (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    profile_picture TEXT,
    location TEXT,
    points INT DEFAULT 0,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI PROFILE TABLE
CREATE TABLE ai_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES user_rewear(id) ON DELETE CASCADE,
    color_type VARCHAR(50),           -- e.g., Warm Autumn
    body_shape VARCHAR(50),           -- e.g., Rectangle, Pear
    palette JSONB,                    -- Optional: store color hex values
    recommendations TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CLOTHING ITEMS TABLE
CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES user_rewear(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),              -- e.g., Tops, Pants
    type VARCHAR(50),                  -- e.g., Casual, Formal
    size VARCHAR(20),                  -- e.g., M, L, 32
    condition VARCHAR(30),             -- e.g., New, Like New
    tags TEXT[],
    is_available BOOLEAN DEFAULT TRUE,
    listed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ITEM IMAGES TABLE
CREATE TABLE item_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES items(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL
);

-- SWAP REQUESTS TABLE
CREATE TABLE swaps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id UUID REFERENCES user_rewear(id),
    to_user_id UUID REFERENCES user_rewear(id),
    offered_item_id UUID REFERENCES items(id),
    requested_item_id UUID REFERENCES items(id),
    status VARCHAR(20) DEFAULT 'pending',  -- pending, accepted, rejected, cancelled, completed
    used_points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FEEDBACK TABLE
CREATE TABLE feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    swap_id UUID REFERENCES swaps(id) ON DELETE SET NULL,
    from_user_id UUID REFERENCES user_rewear(id),
    to_user_id UUID REFERENCES user_rewear(id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ADMIN LOGS TABLE
CREATE TABLE admin_logs_rewear (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID REFERENCES user_rewear(id),
    action_type VARCHAR(100),              -- e.g., reject_item, ban_user
    target_id UUID,                        -- Can reference item/user/etc.
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- NOTIFICATIONS TABLE
CREATE TABLE notifications_rewear (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES user_rewear(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
