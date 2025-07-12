import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { UserRewear } from '../lib/supabase';

interface AuthContextType {
  user: UserRewear | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<{ error?: string }>;
  signOut: () => Promise<void>;
  isAdmin: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<UserRewear | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if user is already logged in
    checkUser();

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === 'SIGNED_IN' && session?.user) {
        await fetchUserProfile(session.user.id);
      } else if (event === 'SIGNED_OUT') {
        setUser(null);
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  async function checkUser() {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      if (session?.user) {
        await fetchUserProfile(session.user.id);
      }
    } catch (error) {
      console.error('Error checking user:', error);
    } finally {
      setLoading(false);
    }
  }

  async function fetchUserProfile(userId: string) {
    try {
      const { data, error } = await supabase
        .from('user_rewear')
        .select('*')
        .eq('id', userId)
        .single();

      if (error) throw error;
      setUser(data);
    } catch (error) {
      console.error('Error fetching user profile:', error);
      setUser(null);
    }
  }

  async function signIn(email: string, password: string) {
    try {
      // First, try to find the user in user_rewear table
      const { data: userProfile, error: profileError } = await supabase
        .from('user_rewear')
        .select('*')
        .eq('email', email)
        .single();

      if (profileError || !userProfile) {
        return { error: 'User not found' };
      }

      // Check if user is admin
      if (!userProfile.is_admin && !userProfile.isAdmin) {
        return { error: 'Access denied. Admin privileges required.' };
      }

      // For demo purposes, check password directly (in production, use proper auth)
      if (userProfile.password !== password) {
        return { error: 'Invalid password' };
      }

      // Set the user directly for demo purposes
      setUser(userProfile);
      return {};

      // Original Supabase auth code (commented out for demo)
      /*
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      if (data.user) {
        await fetchUserProfile(data.user.id);
        
        // Check if user is admin
        const { data: userProfile } = await supabase
          .from('user_rewear')
          .select('is_admin')
          .eq('id', data.user.id)
          .single();

        if (!userProfile?.is_admin) {
          await supabase.auth.signOut();
          return { error: 'Access denied. Admin privileges required.' };
        }
      }

      return {};
      */
    } catch (error) {
      return { error: error instanceof Error ? error.message : 'Sign in failed' };
    }
  }

  async function signOut() {
    // For demo purposes, just clear the user
    setUser(null);
    
    // Original Supabase auth code (commented out for demo)
    // await supabase.auth.signOut();
  }

  const value = {
    user,
    loading,
    signIn,
    signOut,
    isAdmin: user?.is_admin || user?.isAdmin || false,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}