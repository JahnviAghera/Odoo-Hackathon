import React, { useState } from 'react';
import { Send, Eye, Calendar, Users } from 'lucide-react';
import { useNotifications, useUsers } from '../hooks/useSupabaseData';
import { supabase } from '../lib/supabase';

export default function Announcements() {
  const { notifications: announcements, loading, error, refetch } = useNotifications();
  const { users } = useUsers();
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [newAnnouncement, setNewAnnouncement] = useState({
    message: ''
  });

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-emerald-500"></div>
      </div>
    );
  }

  if (error) return <div className="text-red-600">Error: {error}</div>;

  const handleSendAnnouncement = async () => {
    if (!newAnnouncement.message.trim()) return;

    try {
      // Send notification to all users
      const notifications = users.map(user => ({
        user_id: user.id,
        message: newAnnouncement.message,
        is_read: false
      }));

      const { error } = await supabase
        .from('notifications_rewear')
        .insert(notifications);

      if (error) throw error;
      
      refetch();
      setShowCreateModal(false);
      setNewAnnouncement({ message: '' });
    } catch (err) {
      console.error('Error sending announcement:', err);
    }

    console.log('Sending announcement:', newAnnouncement);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-3xl font-bold text-stone-800">Platform Announcements</h1>
        <button
          onClick={() => setShowCreateModal(true)}
          className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors"
        >
          <Send size={20} />
          Create Announcement
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
              <Send className="w-6 h-6 text-blue-600" />
            </div>
            <div>
              <p className="text-stone-500 text-sm font-medium">Total Sent</p>
              <p className="text-2xl font-bold text-stone-800">{announcements.length}</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
              <Users className="w-6 h-6 text-emerald-600" />
            </div>
            <div>
              <p className="text-stone-500 text-sm font-medium">Total Reach</p>
              <p className="text-2xl font-bold text-stone-800">{users.length * announcements.length}</p>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
              <Calendar className="w-6 h-6 text-purple-600" />
            </div>
            <div>
              <p className="text-stone-500 text-sm font-medium">This Month</p>
              <p className="text-2xl font-bold text-stone-800">3</p>
            </div>
          </div>
        </div>
      </div>

      {/* Announcements History */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200">
        <div className="p-6 border-b border-stone-200">
          <h3 className="text-lg font-semibold text-stone-800">Announcement History</h3>
        </div>
        <div className="divide-y divide-stone-200">
          {announcements.map((announcement) => (
            <div key={announcement.id} className="p-6 hover:bg-stone-50 transition-colors">
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1">
                  <p className="text-stone-600 mb-3 line-clamp-2">{announcement.message}</p>
                  <div className="flex items-center gap-4 text-sm text-stone-500">
                    <div className="flex items-center gap-1">
                      <Calendar size={16} />
                      <span>{new Date(announcement.created_at).toLocaleDateString()}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Users size={16} />
                      <span>1 recipient</span>
                    </div>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <span className="px-3 py-1 bg-emerald-100 text-emerald-800 rounded-full text-sm font-medium">
                    sent
                  </span>
                  <button className="p-2 text-stone-600 hover:text-stone-800 hover:bg-stone-100 rounded-lg transition-colors">
                    <Eye size={16} />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Create Announcement Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-lg">
            <h3 className="text-lg font-semibold text-stone-800 mb-4">Create New Announcement</h3>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-stone-700 mb-2">
                  Message
                </label>
                <textarea
                  value={newAnnouncement.message}
                  onChange={(e) => setNewAnnouncement({ ...newAnnouncement, message: e.target.value })}
                  placeholder="Enter your announcement message..."
                  className="w-full px-4 py-3 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  rows={4}
                />
              </div>

              <div className="bg-stone-50 rounded-lg p-4">
                <div className="flex items-center gap-2 text-sm text-stone-600">
                  <Users size={16} />
                  <span>This announcement will be sent to all {users.length} active users</span>
                </div>
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setShowCreateModal(false)}
                className="flex-1 px-4 py-2 text-stone-600 bg-stone-100 rounded-lg hover:bg-stone-200 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSendAnnouncement}
                disabled={!newAnnouncement.message}
                className="flex-1 px-4 py-2 text-white bg-emerald-600 rounded-lg hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Send Announcement
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}