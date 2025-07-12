import React, { useState } from 'react';
import { Download, TrendingUp, Calendar, Filter } from 'lucide-react';

const reportData = {
  totalSwaps: 892,
  completedSwaps: 645,
  cancelledSwaps: 86,
  rejectedSwaps: 61,
  totalUsers: 2847,
  activeUsers: 1934,
  newUsers: 156,
  totalItems: 1429,
  availableItems: 987,
  pendingItems: 321,
  rejectedItems: 121
};

const monthlyData = [
  { month: 'Aug', swaps: 145, users: 2234, items: 289 },
  { month: 'Sep', swaps: 167, users: 2367, items: 321 },
  { month: 'Oct', swaps: 189, users: 2490, items: 356 },
  { month: 'Nov', swaps: 201, users: 2634, items: 398 },
  { month: 'Dec', swaps: 234, users: 2756, items: 445 },
  { month: 'Jan', swaps: 267, users: 2847, items: 489 }
];

export default function Reports() {
  const [selectedReport, setSelectedReport] = useState('overview');
  const [dateRange, setDateRange] = useState('6months');

  const handleDownloadCSV = (reportType: string) => {
    console.log(`Downloading ${reportType} CSV report...`);
    // In a real app, this would trigger a CSV download
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <h1 className="text-3xl font-bold text-stone-800">Reports & Analytics</h1>
        <div className="flex items-center gap-3">
          <select
            value={dateRange}
            onChange={(e) => setDateRange(e.target.value)}
            className="px-4 py-2 border border-stone-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
          >
            <option value="1month">Last Month</option>
            <option value="3months">Last 3 Months</option>
            <option value="6months">Last 6 Months</option>
            <option value="1year">Last Year</option>
          </select>
          <button
            onClick={() => handleDownloadCSV('overview')}
            className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors"
          >
            <Download size={20} />
            Export CSV
          </button>
        </div>
      </div>

      {/* Report Navigation */}
      <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
        <div className="flex gap-2 overflow-x-auto">
          {[
            { id: 'overview', label: 'Overview' },
            { id: 'swaps', label: 'Swap Analytics' },
            { id: 'users', label: 'User Growth' },
            { id: 'listings', label: 'Listing Stats' },
            { id: 'feedback', label: 'User Feedback' }
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setSelectedReport(tab.id)}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                selectedReport === tab.id
                  ? 'bg-emerald-100 text-emerald-700'
                  : 'text-stone-600 hover:bg-stone-100'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-stone-500 text-sm font-medium">Total Swaps</p>
              <p className="text-2xl font-bold text-stone-800">{reportData.totalSwaps.toLocaleString()}</p>
              <p className="text-emerald-600 text-sm">+23% this month</p>
            </div>
            <div className="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-emerald-600" />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-stone-500 text-sm font-medium">Active Users</p>
              <p className="text-2xl font-bold text-stone-800">{reportData.activeUsers.toLocaleString()}</p>
              <p className="text-emerald-600 text-sm">+12% this month</p>
            </div>
            <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-stone-500 text-sm font-medium">Completion Rate</p>
              <p className="text-2xl font-bold text-stone-800">
                {((reportData.completedSwaps / reportData.totalSwaps) * 100).toFixed(1)}%
              </p>
              <p className="text-emerald-600 text-sm">+3% this month</p>
            </div>
            <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-stone-500 text-sm font-medium">Available Items</p>
              <p className="text-2xl font-bold text-stone-800">
                {((reportData.availableItems / reportData.totalItems) * 100).toFixed(1)}%
              </p>
              <p className="text-emerald-600 text-sm">+5% this month</p>
            </div>
            <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-orange-600" />
            </div>
          </div>
        </div>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold text-stone-800">Monthly Swap Trends</h3>
            <button
              onClick={() => handleDownloadCSV('swaps')}
              className="text-emerald-600 hover:text-emerald-700 transition-colors"
            >
              <Download size={20} />
            </button>
          </div>
          <div className="h-64 flex items-end justify-between gap-4">
            {monthlyData.map((data, index) => (
              <div key={index} className="flex-1 flex flex-col items-center">
                <div
                  className="w-full bg-emerald-200 rounded-t-lg transition-all hover:bg-emerald-300"
                  style={{ height: `${(data.swaps / 300) * 100}%` }}
                />
                <span className="text-sm text-stone-500 mt-2">{data.month}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white rounded-xl p-6 shadow-sm border border-stone-200">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-semibold text-stone-800">User Growth</h3>
            <button
              onClick={() => handleDownloadCSV('users')}
              className="text-emerald-600 hover:text-emerald-700 transition-colors"
            >
              <Download size={20} />
            </button>
          </div>
          <div className="h-64 flex items-end justify-between gap-4">
            {monthlyData.map((data, index) => (
              <div key={index} className="flex-1 flex flex-col items-center">
                <div
                  className="w-full bg-blue-200 rounded-t-lg transition-all hover:bg-blue-300"
                  style={{ height: `${(data.users / 15000) * 100}%` }}
                />
                <span className="text-sm text-stone-500 mt-2">{data.month}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Detailed Tables */}
      <div className="bg-white rounded-xl shadow-sm border border-stone-200">
        <div className="p-6 border-b border-stone-200">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold text-stone-800">Detailed Analytics</h3>
            <div className="flex gap-2">
              <button
                onClick={() => handleDownloadCSV('detailed')}
                className="inline-flex items-center gap-2 px-3 py-2 text-emerald-600 border border-emerald-600 rounded-lg hover:bg-emerald-50 transition-colors"
              >
                <Download size={16} />
                Export Data
              </button>
            </div>
          </div>
        </div>
        
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <h4 className="font-semibold text-stone-800 mb-3">Swap Statistics</h4>
              <div className="space-y-2">
                <div className="flex justify-between">
                  <span className="text-stone-600">Completed</span>
                  <span className="font-medium">{reportData.completedSwaps}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">Cancelled</span>
                  <span className="font-medium">{reportData.cancelledSwaps}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">Rejected</span>
                  <span className="font-medium text-red-600">{reportData.rejectedSwaps}</span>
                </div>
              </div>
            </div>

            <div>
              <h4 className="font-semibold text-stone-800 mb-3">User Analytics</h4>
              <div className="space-y-2">
                <div className="flex justify-between">
                  <span className="text-stone-600">Total Users</span>
                  <span className="font-medium">{reportData.totalUsers}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">Active Users</span>
                  <span className="font-medium">{reportData.activeUsers}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">New This Month</span>
                  <span className="font-medium text-emerald-600">{reportData.newUsers}</span>
                </div>
              </div>
            </div>

            <div>
              <h4 className="font-semibold text-stone-800 mb-3">Item Statistics</h4>
              <div className="space-y-2">
                <div className="flex justify-between">
                  <span className="text-stone-600">Available</span>
                  <span className="font-medium">{reportData.availableItems}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">Pending</span>
                  <span className="font-medium text-orange-600">{reportData.pendingItems}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-stone-600">Rejected</span>
                  <span className="font-medium text-red-600">{reportData.rejectedItems}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}