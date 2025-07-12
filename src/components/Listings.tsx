import React, { useState } from 'react';
import { Search, Filter, Eye, Check, X, AlertTriangle } from 'lucide-react';
import { useItems } from '../hooks/useSupabaseData';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import BulkUpload from './BulkUpload';

export default function Listings() {
  const { user } = useAuth();
  const { items: listings, loading, error, refetch } = useItems();
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [selectedListing, setSelectedListing] = useState<number | null>(null);
  const [showActionModal, setShowActionModal] = useState(false);
  const [actionType, setActionType] = useState<'approve' | 'reject' | null>(null);
  const [reason, setReason] = useState('');

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-emerald-500"></div>
      </div>
    );
  }

  if (error) return <div className="text-red-600">Error: {error}</div>;

  const filteredListings = listings.filter(listing => {
    const matchesSearch = listing.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         listing.user_name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || listing.status === statusFilter;
    const matchesCategory = categoryFilter === 'all' || listing.category === categoryFilter;
    
    return matchesSearch && matchesStatus && matchesCategory;
  });

  const handleAction = (listingId: string, action: 'approve' | 'reject') => {
    setSelectedListing(listingId);
    setActionType(action);
    setShowActionModal(true);
  };

  const confirmAction = async () => {
    if (!selectedListing || !actionType) return;

    try {
      const { error } = await supabase
        .from('items')
        .update({ 
          is_available: actionType === 'approve' 
        })
        .eq('id', selectedListing);

      if (error) throw error;
      refetch();
    } catch (err) {
      console.error('Error updating item:', err);
    }

    console.log(`${actionType} listing ${selectedListing} with reason: ${reason}`);
    setShowActionModal(false);
    setSelectedListing(null);
    setActionType(null);
    setReason('');
  };

  const getItemStatus = (item: any) => {
    if (item.is_available) return 'available';
    // In a real app, you might have a separate status field
    return 'pending';
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-3xl font-bold text-stone-800">Moderate Listings</h1>
        <div className="flex items-center gap-3">
          <BulkUpload />
          <div className="flex items-center gap-2 text-sm text-stone-600">
            <span className="px-2 py-1 bg-orange-100 text-orange-800 rounded-full font-medium">
              {filteredListings.filter(l => !l.is_available).length} Pending Review
            </span>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-stone-400" size={20} />
            <input
              type="text"
              placeholder="Search listings or users..."
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
            <option value="available">Available</option>
            <option value="pending">Pending</option>
          </select>

          <select
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
            className="px-4 py-2 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
          >
            <option value="all">All Categories</option>
            <option value="Outerwear">Outerwear</option>
            <option value="Tops">Tops</option>
            <option value="Dresses">Dresses</option>
            <option value="Accessories">Accessories</option>
            <option value="Footwear">Footwear</option>
          </select>
        </div>
      </div>

      {/* Listings Table */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-stone-50 border-b border-stone-200">
              <tr>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Item</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">User</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Category</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Status</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Date</th>
                <th className="text-left py-4 px-6 font-semibold text-stone-800">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-200">
              {filteredListings.map((listing) => (
                <tr key={listing.id} className="hover:bg-stone-50 transition-colors">
                  <td className="py-4 px-6">
                    <div className="flex items-center gap-3">
                      <img
                        src={listing.image_url || 'https://images.pexels.com/photos/1124460/pexels-photo-1124460.jpeg?auto=compress&cs=tinysrgb&w=100'}
                        alt={listing.title}
                        className="w-12 h-12 rounded-lg object-cover"
                      />
                      <div>
                        <p className="font-medium text-stone-800">{listing.title}</p>
                        <p className="text-sm text-stone-500">{listing.size} • {listing.condition}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-4 px-6 text-stone-600">{listing.user_name}</td>
                  <td className="py-4 px-6 text-stone-600">{listing.category}</td>
                  <td className="py-4 px-6">
                    {(() => {
                      const status = getItemStatus(listing);
                      return (
                    <span className={`inline-block px-3 py-1 rounded-full text-sm font-medium ${
                      status === 'available' ? 'bg-emerald-100 text-emerald-800' :
                      'bg-orange-100 text-orange-800'
                    }`}>
                      {status}
                    </span>
                      );
                    })()}
                  </td>
                  <td className="py-4 px-6 text-stone-600">{new Date(listing.listed_at).toLocaleDateString()}</td>
                  <td className="py-4 px-6">
                    <div className="flex items-center gap-2">
                      <button className="p-2 text-stone-600 hover:text-stone-800 hover:bg-stone-100 rounded-lg transition-colors">
                        <Eye size={16} />
                      </button>
                      {!listing.is_available && (
                        <>
                          <button
                            onClick={() => handleAction(listing.id, 'approve')}
                            className="p-2 text-emerald-600 hover:text-emerald-800 hover:bg-emerald-50 rounded-lg transition-colors"
                          >
                            <Check size={16} />
                          </button>
                          <button
                            onClick={() => handleAction(listing.id, 'reject')}
                            className="p-2 text-red-600 hover:text-red-800 hover:bg-red-50 rounded-lg transition-colors"
                          >
                            <X size={16} />
                          </button>
                        </>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Action Modal */}
      {showActionModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-md">
            <h3 className="text-lg font-semibold text-stone-800 mb-4">
              {actionType === 'approve' ? 'Approve' : 'Reject'} Listing
            </h3>
            <p className="text-stone-600 mb-4">
              {actionType === 'approve' 
                ? 'Are you sure you want to approve this listing?' 
                : 'Please provide a reason for rejecting this listing:'
              }
            </p>
            {actionType === 'reject' && (
              <textarea
                value={reason}
                onChange={(e) => setReason(e.target.value)}
                placeholder="Enter rejection reason..."
                className="w-full p-3 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 mb-4"
                rows={3}
              />
            )}
            <div className="flex gap-3">
              <button
                onClick={() => setShowActionModal(false)}
                className="flex-1 px-4 py-2 text-stone-600 bg-stone-100 rounded-lg hover:bg-stone-200 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmAction}
                className={`flex-1 px-4 py-2 text-white rounded-lg transition-colors ${
                  actionType === 'approve' 
                    ? 'bg-emerald-600 hover:bg-emerald-700' 
                    : 'bg-red-600 hover:bg-red-700'
                }`}
              >
                {actionType === 'approve' ? 'Approve' : 'Reject'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}