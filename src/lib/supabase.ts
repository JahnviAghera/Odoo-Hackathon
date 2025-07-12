import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Database types based on your schema
export interface UserRewear {
  id: string
  name: string
  email: string
  password: string
  profile_picture?: string
  location?: string
  points: number
  is_admin: boolean
  created_at: string
}

export interface Item {
  id: string
  user_id: string
  title: string
  description?: string
  category?: string
  type?: string
  size?: string
  condition?: string
  tags?: string[]
  is_available: boolean
  listed_at: string
  price?: number
}

export interface ItemImage {
  id: string
  item_id: string
  image_url: string
}

export interface Swap {
  id: string
  from_user_id: string
  to_user_id: string
  offered_item_id: string
  requested_item_id: string
  status: 'pending' | 'accepted' | 'rejected' | 'cancelled' | 'completed'
  used_points: number
  created_at: string
  updated_at: string
}

export interface Feedback {
  id: string
  swap_id?: string
  from_user_id: string
  to_user_id: string
  rating: number
  comment?: string
  created_at: string
}

export interface AdminLog {
  id: string
  admin_id: string
  action_type: string
  target_id: string
  details?: string
  created_at: string
}

export interface NotificationRewear {
  id: string
  user_id: string
  message: string
  is_read: boolean
  created_at: string
}

export interface AIProfile {
  id: string
  user_id: string
  color_type?: string
  body_shape?: string
  palette?: any
  recommendations?: string
  updated_at: string
}