![ReWear Logo](https://github.com/JahnviAghera/Odoo-Hackathon/blob/89622941f168e3666a01fcf4d1554793c2384fc5/logo.png)

# Odoo-Hackathon  
## ReWear – Community Clothing Exchange

ReWear is a cross-platform Flutter application that promotes sustainable fashion through community-driven clothing exchange. Users can upload garments, browse items, swap clothing, and receive styling recommendations. The app is supported by Supabase, providing real-time backend services, authentication, and secure storage.

---

## Figma Design  
[Click here to view the Figma Design](https://www.figma.com/design/o2zAh6YwHHJsjGRa7a9N0P/Untitled?t=U34MP37HOgPu9FGG-1)

---

## Key Features

### Authentication  
- Email/password signup and login  
- Supabase Auth integration

### Core User Features  
- Upload clothing items with images and descriptions  
- Browse, filter, and search available items  
- Swap clothing or redeem items via points  
- Manage profile and view point balance  
- Get AI-powered style recommendations

### Admin Panel  
[Admin Panel Link](https://rewearadmin.netlify.app/)
- Approve or reject item listings  
- Remove spam or inappropriate content  
- View logs of admin actions

---

## Repository Structure

- `master` branch: Contains the mobile Flutter application code  
- `admin_panel` branch: Contains the admin dashboard code  

---

## Database Design (Supabase)

Supabase provides a managed PostgreSQL database with real-time synchronization, authentication, and secure access rules.

### Security Features

- UUIDs for all primary keys for increased security  
- Passwords hashed using secure algorithms like bcrypt  
- Foreign key constraints to maintain data integrity  
- Input validation on both client and server sides  
- Row Level Security (RLS) for data access control  
- Admin logs for auditing and transparency  
- Least privilege access model for database users

### Tables

- `user_rewear`: User profile data  
- `ai_profiles`: AI-generated style profiles  
- `items`: Clothing item metadata  
- `item_images`: Associated image URLs  
- `swaps`: Clothing exchange transactions  
- `feedback`: Ratings and reviews  
- `rewards`: Rewards and incentives  
- `user_rewards`: Track claimed rewards  
- `notifications_rewear`: System notifications  
- `admin_logs_rewear`: Admin activities and moderation logs  

Includes a `redeem_reward` stored procedure for point-based reward redemption.

---

## Coding Standards

- Input validation on frontend and backend  
- Dynamic data loading using Supabase queries  
- Modular and reusable widgets (e.g., `_ctaButton`)  
- Optimized performance through caching and minimal network calls  
- Error handling with clear fallback messages  
- Code linting for consistency  
- Maintainable architecture with separation of concerns

---

## UI/UX Design

- Responsive layout across mobile, web, and desktop  
- Pagination and filtering for item lists  
- Accessible design with clear color contrast  
- Consistent and clean user interface  

---

## Key Files

- `lib/main.dart`: Entry point and Supabase setup  
- `lib/auth.dart`: Handles authentication logic  
- `lib/home.dart`: Displays dashboard and trending items  
- `lib/supabase_client.dart`: Supabase configuration  
- `lib/models/`: Data models like `ClothingItem`  
- `lib/features/`: Modules for swapping, rewards, recommendations  
- `lib/screens/`: Different UI screens like chat and onboarding  
- `lib/widgets/`: Reusable UI components

---

## Team Collaboration

All team members contributed to design, development, integration, and testing of the application. Work was divided by features, and collaboration was handled using Git.

---
[![Watch the video]]([https://youtu.be/vt5fpE0bzSY](https://youtu.be/w0-N4u-KD4g?si=D4Nro-tpsj2tDvFK))


*Add your preferred open-source license here (e.g., MIT, Apache 2.0)*

---

If you believe in sustainable fashion and reusability, feel free to support the project.
