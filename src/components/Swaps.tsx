import React, { useState } from 'react';
import { Search, Eye, X, AlertTriangle, RefreshCw } from 'lucide-react';
import { useSwaps } from '../hooks/useSupabaseData';
import { supabase } from '../lib/supabase';

export default function Swaps() {
  const { swaps, loading, error, refetch } = useSwaps();
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [selectedSwap, setSelectedSwap] = useState<number | null>(null);
  const [showCancelModal, setShowCancelModal] = useState(false);
  const [cancelReason, setCancelReason] = useState('');

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-emerald-500"></div>
      </div>
    );
  }

  if (error) return <div className="text-red-600">Error: {error}</div>;

  const filteredSwaps = swaps.filter(swap => {
    const matchesSearch = swap.from_user_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         swap.to_user_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         swap.offered_item_title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         swap.requested_item_title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || swap.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  const handleCancelSwap = (swapId: string) => {
    setSelectedSwap(swapId);
    setShowCancelModal(true);
  };

  const confirmCancel = async () => {
    if (!selectedSwap) return;

    try {
      const { error } = await supabase
        .from('swaps')
        .update({ status: 'cancelled' })
        .eq('id', selectedSwap);

      if (error) throw error;
      refetch();
    } catch (err) {
      console.error('Error cancelling swap:', err);
    }

    console.log(`Cancel swap ${selectedSwap} with reason: ${cancelReason}`);
    setShowCancelModal(false);
    setSelectedSwap(null);
    setCancelReason('');
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed':
        return 'bg-emerald-100 text-emerald-800';
      case 'pending':
        return 'bg-blue-100 text-blue-800';
      case 'accepted':
        return 'bg-purple-100 text-purple-800';
      case 'rejected':
        return 'bg-red-100 text-red-800';
      case 'cancelled':
        return 'bg-stone-100 text-stone-800';
      default:
        return 'bg-stone-100 text-stone-800';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-3xl font-bold text-stone-800">Monitor Swaps</h1>
        <div className="flex items-center gap-2 text-sm">
          <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded-full font-medium">
            {filteredSwaps.filter(s => s.status === 'pending' || s.status === 'accepted').length} Active
          </span>
          <span className="px-2 py-1 bg-red-100 text-red-800 rounded-full font-medium">
            {filteredSwaps.filter(s => s.status === 'rejected').length} Rejected
          </span>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-stone-400" size={20} />
            <input
              type="text"
              placeholder="Search swaps, users, or items..."
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
            <option value="pending">Pending</option>
            <option value="accepted">Accepted</option>
            <option value="completed">Completed</option>
            <option value="rejected">Rejected</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>
      </div>

      {/* Swaps Table */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-stone-50 border-b border-stone-200">
              <tr>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Swap Details</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Participants</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Value Exchange</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Status</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Date</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-200">
              {filteredSwaps.map((swap) => (
                <tr key={swap.id} className="hover:bg-stone-50 transition-colors">
                  <td className="py-4 px-6">
                    <div className="space-y-1">
                      <p className="font-medium text-stone-800">
                        {swap.offered_item_title} ↔ {swap.requested_item_title}
                      </p>
                      <p className="text-sm text-stone-500">Swap ID: #{swap.id}</p>
                    </div>
                  </td>
                  <td className="py-4 px-6">
                    <div className="space-y-1">
                      <p className="text-stone-800">
                        <span className="font-medium">{swap.from_user_name}</span> → {swap.to_user_name}
                      </p>
                      <p className="text-sm text-stone-500">Requester → Provider</p>
                    </div>
                  </td>
                  <td className="py-4 px-6">
                    <div className="text-sm text-stone-700">
                      {swap.used_points > 0 ? (
                        <span className="font-medium text-emerald-600">{swap.used_points} points used</span>
                      ) : (
                        <span className="text-stone-500">Direct swap</span>
                      )}
                    </div>
                  </td>
                  <td className="py-4 px-6">
                    <span className={`inline-block px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(swap.status)}`}>
                      {swap.status}
                    </span>
                  </td>
                  <td className="py-4 px-6 text-stone-600">{new Date(swap.created_at).toLocaleDateString()}</td>
                  <td className="py-4 px-6">
                    <div className="flex items-center gap-2">
                      <button className="p-2 text-stone-600 hover:text-stone-800 hover:bg-stone-100 rounded-lg transition-colors">
                        <Eye size={16} />
                      </button>
                      {(swap.status === 'pending' || swap.status === 'accepted') && (
                        <button
                          onClick={() => handleCancelSwap(swap.id)}
                          className="p-2 text-red-600 hover:text-red-800 hover:bg-red-50 rounded-lg transition-colors"
                        >
                          <X size={16} />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Cancel Modal */}
      {showCancelModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-md">
            <h3 className="text-lg font-semibold text-stone-800 mb-4">Cancel Swap</h3>
            <p className="text-stone-600 mb-4">
              Please provide a reason for cancelling this swap:
            </p>
            <textarea
              value={cancelReason}
              onChange={(e) => setCancelReason(e.target.value)}
              placeholder="Enter cancellation reason..."
              className="w-full p-3 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 mb-4"
              rows={3}
            />
            <div className="flex gap-3">
              <button
                onClick={() => setShowCancelModal(false)}
                className="flex-1 px-4 py-2 text-stone-600 bg-stone-100 rounded-lg hover:bg-stone-200 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmCancel}
                className="flex-1 px-4 py-2 text-white bg-red-600 rounded-lg hover:bg-red-700 transition-colors"
              >
                Cancel Swap
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}