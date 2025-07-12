import React from 'react';
import { TrendingUp, Users, Package, RefreshCw, AlertTriangle, CheckCircle } from 'lucide-react';
import { useUsers, useItems, useSwaps } from '../hooks/useSupabaseData';

export default function Dashboard() {
  const { users, loading: usersLoading } = useUsers();
  const { items, loading: itemsLoading } = useItems();
  const { swaps, loading: swapsLoading } = useSwaps();

  const loading = usersLoading || itemsLoading || swapsLoading;

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-emerald-500"></div>
      </div>
    );
  }

  const stats = [
    { 
      label: 'Total Users', 
      value: users.length.toLocaleString(), 
      change: '+12%', 
      icon: Users, 
      color: 'bg-blue-500' 
    },
    { 
      label: 'Available Items', 
      value: items.filter(item => item.is_available).length.toLocaleString(), 
      change: '+8%', 
      icon: Package, 
      color: 'bg-emerald-500' 
    },
    { 
      label: 'Active Swaps', 
      value: swaps.filter(swap => ['pending', 'accepted'].includes(swap.status)).length.toLocaleString(), 
      change: '+23%', 
      icon: RefreshCw, 
      color: 'bg-purple-500' 
    },
    { 
      label: 'Pending Items', 
      value: items.filter(item => !item.is_available).length.toLocaleString(), 
      change: '-5%', 
      icon: AlertTriangle, 
      color: 'bg-orange-500' 
    },
  ];

  // Get recent activity from items and swaps
  const recentActivity = [
    ...items.slice(0, 3).map(item => ({
      user: item.user_name,
      action: `Listed ${item.title}`,
      time: new Date(item.listed_at).toLocaleDateString(),
      status: item.is_available ? 'available' : 'pending'
    })),
    ...swaps.slice(0, 2).map(swap => ({
      user: swap.from_user_name,
      action: `${swap.status === 'completed' ? 'Completed' : 'Requested'} swap with ${swap.to_user_name}`,
      time: new Date(swap.created_at).toLocaleDateString(),
      status: swap.status
    }))
  ];

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-stone-800">Dashboard</h1>
        <div className="text-sm text-stone-500">
          Last updated: {new Date().toLocaleString()}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div key={index} className="bg-white rounded-xl p-6 shadow-sm border border-stone-200 hover:shadow-md transition-shadow">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-stone-500 text-sm font-medium">{stat.label}</p>
                  <p className="text-2xl font-bold text-stone-800 mt-1">{stat.value}</p>
                  <p className={`text-sm mt-1 ${stat.change.startsWith('+') ? 'text-emerald-600' : 'text-red-600'}`}>
                    {stat.change} this month
                  </p>
                </div>
                <div className={`w-12 h-12 ${stat.color} rounded-xl flex items-center justify-center`}>
                  <Icon className="w-6 h-6 text-white" />
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <h3 className="text-lg font-semibold text-stone-800 mb-4">User Growth</h3>
          <div className="h-64 flex items-end justify-between gap-2">
            {[40, 65, 45, 80, 60, 90, 75].map((height, index) => (
              <div key={index} className="flex-1 bg-emerald-200 rounded-t" style={{ height: `${height}%` }} />
            ))}
          </div>
          <div className="flex justify-between mt-2 text-sm text-stone-500">
            <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <h3 className="text-lg font-semibold text-stone-800 mb-4">Swap Categories</h3>
          <div className="space-y-4">
            {[
              { category: 'Tops', percentage: 35, color: 'bg-emerald-500' },
              { category: 'Dresses', percentage: 25, color: 'bg-blue-500' },
              { category: 'Pants', percentage: 20, color: 'bg-purple-500' },
              { category: 'Accessories', percentage: 12, color: 'bg-orange-500' },
              { category: 'Outerwear', percentage: 8, color: 'bg-pink-500' },
            ].map((item, index) => (
              <div key={index} className="flex items-center gap-4">
                <span className="text-sm text-stone-600 w-24">{item.category}</span>
                <div className="flex-1 bg-stone-200 rounded-full h-2">
                  <div className={`${item.color} h-2 rounded-full`} style={{ width: `${item.percentage}%` }} />
                </div>
                <span className="text-sm font-medium text-stone-800 w-12">{item.percentage}%</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200">
        <div className="p-6 border-b border-stone-200">
          <h3 className="text-lg font-semibold text-stone-800">Recent Activity</h3>
        </div>
        <div className="divide-y divide-stone-200">
          {recentActivity.map((activity, index) => (
            <div key={index} className="p-6 flex items-center justify-between hover:bg-stone-50 transition-colors">
              <div className="flex items-center gap-4">
                <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                  activity.status === 'completed' ? 'bg-emerald-100' :
                  activity.status === 'available' ? 'bg-green-100' :
                  activity.status === 'flagged' ? 'bg-red-100' : 'bg-orange-100'
                }`}>
                  <CheckCircle className={`w-5 h-5 ${
                    activity.status === 'completed' ? 'text-emerald-600' :
                    activity.status === 'available' ? 'text-green-600' :
                    activity.status === 'flagged' ? 'text-red-600' : 'text-orange-600'
                  }`} />
                </div>
                <div>
                  <p className="font-medium text-stone-800">{activity.user}</p>
                  <p className="text-sm text-stone-600">{activity.action}</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-sm text-stone-500">{activity.time}</p>
                <span className={`inline-block px-2 py-1 rounded-full text-xs font-medium ${
                  activity.status === 'completed' ? 'bg-emerald-100 text-emerald-800' :
                  activity.status === 'available' ? 'bg-green-100 text-green-800' :
                  activity.status === 'flagged' ? 'bg-red-100 text-red-800' : 'bg-orange-100 text-orange-800'
                }`}>
                  {activity.status}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}