![ReWear Logo](https://github.com/JahnviAghera/Odoo-Hackathon/blob/89622941f168e3666a01fcf4d1554793c2384fc5/logo.png)

# Odoo-Hackathon  
## ReWear – Community Clothing Exchange ♻️

ReWear is a cross-platform Flutter application that promotes sustainable fashion through community-driven clothing exchange. Users can upload garments, browse items, swap clothing, and receive styling recommendations. The app is supported by **Supabase**, providing real-time backend services, authentication, and secure storage.

---

## 🔗 Figma Design  
[Click here to view the Figma Design](https://www.figma.com/design/o2zAh6YwHHJsjGRa7a9N0P/Untitled?t=U34MP37HOgPu9FGG-1)

---

## 🌟 Key Features

### 🔐 Authentication  
- Secure email/password signup and login  
- Managed by Supabase Auth

### 🧥 Core User Features  
- Upload items with images and metadata  
- Browse and filter clothing items  
- Request swaps or redeem items via point system  
- View profile, point balance, and swap history  
- AI-powered styling assistance  

### 🖥️ Admin Panel  
- Approve/reject listings  
- Moderate spam/inappropriate content  
- Track admin activity via logs  

---

## 📁 Repository Structure

- **`master` branch:** Mobile Flutter application  
- **`admin_panel` branch:** Admin control interface  

---

## 🧩 Database Design (Powered by Supabase)

ReWear uses a robust Supabase-managed PostgreSQL database designed with security, scalability, and relational integrity in mind.

### 🔐 Security Highlights

- **UUIDs for Primary Keys**: Ensures unique, non-guessable identifiers  
- **Password Hashing**: User passwords are securely hashed (e.g., bcrypt)  
- **RLS (Row Level Security)**: Enforces user-specific data access  
- **Foreign Key Constraints**: Maintain referential integrity  
- **Admin Logs**: Activity tracking for moderation transparency  
- **Data Validation**: Input checks on frontend and backend  
- **Least Privilege Principle**: Minimal permission roles for safety  

### 📚 Key Tables

- `user_rewear` – User profiles  
- `items` – Clothing items  
- `item_images` – Image metadata  
- `swaps` – Swap requests  
- `feedback` – Ratings and comments  
- `rewards` – Reward definitions  
- `user_rewards` – Claimed rewards  
- `notifications_rewear` – System messages  
- `admin_logs_rewear` – Admin activity tracking  
- `ai_profiles` – AI-generated body/style profiles

Stored Procedure:  
- `redeem_reward` – Deducts user points and logs rewards  

---

## ✅ Coding Standards

- **Data Validation**: Frontend and backend level  
- **Reusable Widgets**: e.g., `_ctaButton` for actions  
- **Dynamic UI**: Data fetched via Supabase for real-time updates  
- **Error Handling**: Graceful feedback with snackbars  
- **Linter Enforced**: For clean, consistent code  
- **Optimized Performance**: Image caching, prefetching  

---

## 💡 UI/UX Design Principles

- **Responsive Layouts**: Works across devices (mobile, web, desktop)  
- **Pagination & Search**: For better item browsing  
- **Accessible & Aesthetic**: High contrast, user-friendly navigation  

---

## 🔧 Key Files

- `lib/main.dart`: App entry point  
- `lib/auth.dart`: Login & registration  
- `lib/home.dart`: Main screen & item feed  
- `lib/supabase_client.dart`: Supabase config  
- `lib/models/`: Data models like `ClothingItem`  
- `lib/features/`: Modules like browse, upload, rewards  
- `lib/widgets/`: Reusable UI elements  
- `lib/screens/`: Screens like chat, setup wizard  

---

## 👥 Team Collaboration

All team members actively contributed to features, UI/UX, backend integration, and testing. We followed agile principles to iterate quickly and deliver quality.

---

## 📜 License

*Include your preferred license here (MIT, Apache 2.0, etc.)*

---

Feel free to ⭐ the repo if you support sustainable fashion!
