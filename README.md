# Rewear Project

ReWear is a cross-platform Flutter application designed to facilitate clothing exchange and styling assistance. Built with Flutter, it can be deployed on multiple platforms including Android, iOS, web, and desktop, providing a consistent user experience across devices. It leverages Supabase for backend services, providing user authentication, data storage, and real-time updates.

## Project Overview

The application allows users to:

*   Upload clothing items with images and descriptions.
*   Browse available items based on various criteria.
*   Get style recommendations and assistance.
*   Manage their user profiles.
*   Swap clothing items with other users.

## Database Design (15%)

The project utilizes Supabase as a backend service, which provides a managed PostgreSQL database. The database schema is designed to support the application's features, ensure data integrity, and enhance security.

### Security Considerations

The database schema incorporates several security measures:

*   **UUIDs for Primary Keys:** Universally Unique Identifiers (UUIDs) are used as primary keys for all tables. UUIDs are less predictable than sequential integers, making it more difficult for malicious actors to guess or enumerate valid IDs.
*   **Password Hashing:** User passwords are not stored in plain text. Instead, they are hashed using a strong hashing algorithm (e.g., bcrypt) before being stored in the `password_hash` column of the `user_rewear` table. This prevents unauthorized access to user passwords even if the database is compromised.
*   **Foreign Key Constraints:** Foreign key constraints are used to enforce relationships between tables and prevent orphaned records. For example, the `user_id` column in the `items` table is a foreign key referencing the `id` column in the `user_rewear` table. This ensures that clothing items are always associated with a valid user.
*   **Data Validation:** Input validation is performed on both the client-side and server-side to prevent SQL injection attacks and ensure data quality. For example, the `rating` column in the `feedback` table has a `CHECK` constraint to ensure that the rating is within the valid range (1-5).
*   **Least Privilege Principle:** Database users and roles are granted only the minimum necessary privileges to perform their tasks. This limits the potential damage that can be caused by a compromised account.
*   **Row Level Security (RLS):** Supabase's Row Level Security (RLS) can be used to control access to data based on user roles and permissions. This allows fine-grained control over who can access and modify specific data rows.
*   **Auditing:** Admin actions are logged in the `admin_logs_rewear` table to provide an audit trail of administrative activities. This helps to detect and investigate suspicious behavior.

<!-- ### Database Schema

```sql
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
```

The database schema includes tables for:

*   `user_rewear`: Stores user information, including profile details and preferences.
*   `ai_profiles`: Stores AI profile information.
*   `items`: Stores clothing item details, including title, description, category, price, and associated images.
*   `item_images`: Stores image URLs for clothing items.
*   `swaps`: Stores swap request details.
*   `feedback`: Stores feedback on swaps.
*   `admin_logs_rewear`: Stores admin logs.
*   `notifications_rewear`: Stores user notifications.
*   `rewards`: Stores reward information.
*   `user_rewards`: Stores user rewards.

The `redeem_reward` stored procedure is used to redeem rewards by deducting points from the user and inserting a record into the `user_rewards` table.

The database schema is designed with proper relationships and data types to ensure data integrity and efficient querying. Real-time synchronization is achieved through Supabase's real-time capabilities. -->

## Coding Standards (40%)

*   **Data Validation:** User inputs are validated on both the frontend and backend to ensure data quality and prevent errors.
*   **Dynamic Values:** The application avoids hardcoding values by fetching data from Supabase and using dynamic UI updates.
*   **Code Reusability:** The codebase is structured with modular, reusable components and functions to avoid repetition and improve maintainability. For example, the `_ctaButton` widget in `lib/home.dart` is used to create multiple call-to-action buttons with consistent styling.
*   **Performance:** The application is designed to load quickly and minimize network calls. Image caching and data pre-fetching techniques are employed to enhance performance.
*   **Error Handling:** The application handles invalid inputs and system errors gracefully, providing fallback messages to the user. For example, the `_fetchUserData` and `_fetchClothingItems` functions in `lib/home.dart` include error handling to display snackbar messages in case of data fetching failures.
*   **Linter:** A linter is used to ensure coding standards are followed throughout the project.
*   **Complexity:** The codebase is designed to be maintainable and understandable, with clear separation of concerns and well-defined modules.

## UI/UX Design (15%)

*   **Responsive:** The application is designed to be responsive and adapt to different screen sizes and devices.
*   **Pagination:** The browse items feature includes pagination to allow users to navigate through large lists of clothing items.
*   **Search and Filter:** The browse items feature includes search and filter options to help users find specific items.
*   **Color Combination:** The application uses a consistent color palette with proper font color contrast to ensure readability and visual appeal.

## Team Collaboration (10%)

All team members are actively involved in the coding process, contributing to different features and modules of the application.

## Key Files

*   `lib/main.dart`: The entry point of the application, responsible for initializing Supabase and setting up the main UI.
*   `lib/auth.dart`: Handles user authentication, including login and registration.
*   `lib/home.dart`: The main screen of the application, displaying user information, trending items, and recommended items.
*   `lib/supabase_client.dart`: Initializes the Supabase client.
*   `lib/features/...`: Contains the implementation of various features, such as body type analysis, browsing, rewards, style helper, swapping, and uploading.
*   `lib/models/...`: Defines the data models used in the application, such as `ClothingItem`.
*   `lib/screens/...`: Contains the implementation of various screens, such as the chat screen and optional setup screen.
*   `lib/widgets/...`: Contains reusable widgets used throughout the application.
