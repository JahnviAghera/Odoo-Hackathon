import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import type { UserRewear, Item, Swap, NotificationRewear } from '../lib/supabase'

export function useUsers() {
  const [users, setUsers] = useState<UserRewear[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchUsers() {
      try {
        const { data, error } = await supabase
          .from('user_rewear')
          .select('*')
          .order('created_at', { ascending: false })

        if (error) throw error
        setUsers(data || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
      } finally {
        setLoading(false)
      }
    }

    fetchUsers()
  }, [])

  return { users, loading, error, refetch: () => window.location.reload() }
}

export function useItems() {
  const [items, setItems] = useState<(Item & { user_name: string, image_url?: string })[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchItems() {
      try {
        const { data, error } = await supabase
          .from('items')
          .select(`
            *,
            user_rewear!inner(name),
            item_images(image_url)
          `)
          .order('listed_at', { ascending: false })

        if (error) throw error
        
        const itemsWithUserNames = data?.map(item => ({
          ...item,
          user_name: item.user_rewear.name,
          image_url: item.item_images?.[0]?.image_url
        })) || []
        
        setItems(itemsWithUserNames)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
      } finally {
        setLoading(false)
      }
    }

    fetchItems()
  }, [])

  return { items, loading, error, refetch: () => window.location.reload() }
}

export function useSwaps() {
  const [swaps, setSwaps] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchSwaps() {
      try {
        const { data, error } = await supabase
          .from('swaps')
          .select(`
            *,
            from_user:user_rewear!swaps_from_user_id_fkey(name),
            to_user:user_rewear!swaps_to_user_id_fkey(name),
            offered_item:items!swaps_offered_item_id_fkey(title),
            requested_item:items!swaps_requested_item_id_fkey(title)
          `)
          .order('created_at', { ascending: false })

        if (error) throw error
        
        const swapsWithDetails = data?.map(swap => ({
          ...swap,
          from_user_name: swap.from_user?.name,
          to_user_name: swap.to_user?.name,
          offered_item_title: swap.offered_item?.title,
          requested_item_title: swap.requested_item?.title
        })) || []
        
        setSwaps(swapsWithDetails)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
      } finally {
        setLoading(false)
      }
    }

    fetchSwaps()
  }, [])

  return { swaps, loading, error, refetch: () => window.location.reload() }
}

export function useNotifications() {
  const [notifications, setNotifications] = useState<NotificationRewear[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function fetchNotifications() {
      try {
        const { data, error } = await supabase
          .from('notifications_rewear')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(50)

        if (error) throw error
        setNotifications(data || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred')
      } finally {
        setLoading(false)
      }
    }

    fetchNotifications()
  }, [])

  return { notifications, loading, error, refetch: () => window.location.reload() }
}