import React, { useState } from 'react';
import { Search, Eye, Ban, Shield, Flag, Star } from 'lucide-react';
import { useUsers } from '../hooks/useSupabaseData';
import { supabase } from '../lib/supabase';

export default function Users() {
  const { users, loading, error, refetch } = useUsers();
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [sortBy, setSortBy] = useState('activity');
  const [selectedUser, setSelectedUser] = useState<number | null>(null);
  const [showBanModal, setShowBanModal] = useState(false);
  const [actionType, setActionType] = useState<'ban' | 'unban' | null>(null);
  const [banReason, setBanReason] = useState('');

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-emerald-500"></div>
      </div>
    );
  }

  if (error) return <div className="text-red-600">Error: {error}</div>;

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || user.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  }).sort((a, b) => {
    // For now, sort by points since we don't have swap/report counts in the schema
    if (sortBy === 'points') return b.points - a.points;
    if (sortBy === 'activity') return b.points - a.points; // Use points as proxy for activity
    if (sortBy === 'reports') return 0; // No reports field in current schema
    return 0;
  });

  const handleUserAction = (userId: string, action: 'ban' | 'unban') => {
    setSelectedUser(userId);
    setActionType(action);
    setShowBanModal(true);
  };

  const confirmAction = async () => {
    if (!selectedUser || !actionType) return;

    try {
      // In a real app, you might have a separate banned_users table or status field
      // For now, we'll just log the action
      console.log(`${actionType} user ${selectedUser} with reason: ${banReason}`);
      // You could add admin logging here
    } catch (err) {
      console.error('Error updating user:', err);
    }

    console.log(`${actionType} user ${selectedUser} with reason: ${banReason}`);
    setShowBanModal(false);
    setSelectedUser(null);
    setActionType(null);
    setBanReason('');
  };

  const getUserStatus = (user: any) => {
    // Since we don't have a status field, determine status based on other factors
    return user.is_admin ? 'admin' : 'active';
  };

  const getStatusColor = (user: any) => {
    const status = getUserStatus(user);
    switch (status) {
      case 'active':
        return 'bg-emerald-100 text-emerald-800';
      case 'admin':
        return 'bg-purple-100 text-purple-800';
      default:
        return 'bg-stone-100 text-stone-800';
    }
  };

  const getUserLevel = (points: number) => {
    if (points >= 1000) return { level: 'Expert', color: 'text-purple-600' };
    if (points >= 500) return { level: 'Advanced', color: 'text-blue-600' };
    if (points >= 200) return { level: 'Intermediate', color: 'text-emerald-600' };
    return { level: 'Beginner', color: 'text-stone-600' };
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-3xl font-bold text-stone-800">User Management</h1>
        <div className="flex items-center gap-2 text-sm">
          <span className="px-2 py-1 bg-emerald-100 text-emerald-800 rounded-full font-medium">
            {filteredUsers.filter(u => !u.is_admin).length} Active
          </span>
          <span className="px-2 py-1 bg-purple-100 text-purple-800 rounded-full font-medium">
            {filteredUsers.filter(u => u.is_admin).length} Admins
          </span>
          <span className="px-2 py-1 bg-red-100 text-red-800 rounded-full font-medium">
            0 Banned
          </span>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-stone-400" size={20} />
            <input
              type="text"
              placeholder="Search users..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
            />
          </div>
          
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-4 py-2 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
          >
            <option value="all">All Status</option>
            <option value="active">Active</option>
          </select>

          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value)}
            className="px-4 py-2 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
          >
            <option value="activity">Sort by Activity</option>
            <option value="points">Sort by Points</option>
          </select>
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-stone-50 border-b border-stone-200">
              <tr>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">User</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Activity</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Level</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Status</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Join Date</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-200">
              {filteredUsers.map((user) => {
                const userLevel = getUserLevel(user.points);
                return (
                  <tr key={user.id} className="hover:bg-stone-50 transition-colors">
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-3">
                        <img
                          src={user.profile_picture || 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=100'}
                          alt={user.name}
                          className="w-12 h-12 rounded-full object-cover"
                        />
                        <div>
                          <p className="font-medium text-stone-800">{user.name}</p>
                          <p className="text-sm text-stone-500">{user.email}</p>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-1">
                        <p className="text-sm text-stone-600">Active user</p>
                        <p className="text-sm text-stone-600">{user.points} points</p>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-1">
                        <p className={`font-medium ${userLevel.color}`}>{userLevel.level}</p>
                        <p className="text-sm text-stone-500">{user.points} pts</p>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <span className={`inline-block px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(user)}`}>
                        {getUserStatus(user)}
                      </span>
                    </td>
                    <td className="py-4 px-6 text-stone-600">{new Date(user.created_at).toLocaleDateString()}</td>
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-2">
                        <button className="p-2 text-stone-600 hover:text-stone-800 hover:bg-stone-100 rounded-lg transition-colors">
                          <Eye size={16} />
                        </button>
                        {!user.is_admin && (
                          <button
                            onClick={() => handleUserAction(user.id, 'ban')}
                            className="p-2 text-red-600 hover:text-red-800 hover:bg-red-50 rounded-lg transition-colors"
                          >
                            <Ban size={16} />
                          </button>
                        )}
                        {false && ( // No banned users in current schema
                          <button
                            onClick={() => handleUserAction(user.id, 'unban')}
                            className="p-2 text-emerald-600 hover:text-emerald-800 hover:bg-emerald-50 rounded-lg transition-colors"
                          >
                            <Shield size={16} />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* Ban/Unban Modal */}
      {showBanModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-md">
            <h3 className="text-lg font-semibold text-stone-800 mb-4">
              {actionType === 'ban' ? 'Ban User' : 'Unban User'}
            </h3>
            <p className="text-stone-600 mb-4">
              {actionType === 'ban' 
                ? 'Please provide a reason for banning this user:' 
                : 'Are you sure you want to unban this user?'
              }
            </p>
            {actionType === 'ban' && (
              <textarea
                value={banReason}
                onChange={(e) => setBanReason(e.target.value)}
                placeholder="Enter ban reason..."
                className="w-full p-3 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 mb-4"
                rows={3}
              />
            )}
            <div className="flex gap-3">
              <button
                onClick={() => setShowBanModal(false)}
                className="flex-1 px-4 py-2 text-stone-600 bg-stone-100 rounded-lg hover:bg-stone-200 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmAction}
                className={`flex-1 px-4 py-2 text-white rounded-lg transition-colors ${
                  actionType === 'ban' 
                    ? 'bg-red-600 hover:bg-red-700' 
                    : 'bg-emerald-600 hover:bg-emerald-700'
                }`}
              >
                {actionType === 'ban' ? 'Ban User' : 'Unban User'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}