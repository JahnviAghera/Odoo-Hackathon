import React from 'react';
import { 
  LayoutDashboard, 
  Package, 
  RefreshCw, 
  Users, 
  Megaphone, 
  BarChart3, 
  Menu, 
  X,
  Leaf,
  LogOut
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface SidebarProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  sidebarOpen: boolean;
  setSidebarOpen: (open: boolean) => void;
}

const menuItems = [
  { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { id: 'listings', label: 'Moderate Listings', icon: Package },
  { id: 'swaps', label: 'Monitor Swaps', icon: RefreshCw },
  { id: 'users', label: 'User Management', icon: Users },
  { id: 'announcements', label: 'Announcements', icon: Megaphone },
  { id: 'reports', label: 'Reports & Analytics', icon: BarChart3 },
];

export default function Sidebar({ activeTab, setActiveTab, sidebarOpen, setSidebarOpen }: SidebarProps) {
  const { user, signOut } = useAuth();

  const handleSignOut = async () => {
    await signOut();
  };

  return (
    <>
      {/* Mobile menu button */}
      <button
        onClick={() => setSidebarOpen(!sidebarOpen)}
        className="lg:hidden fixed top-4 left-4 z-50 p-2 bg-white rounded-lg shadow-md"
      >
        {sidebarOpen ? <X size={24} /> : <Menu size={24} />}
      </button>

      {/* Sidebar overlay for mobile */}
      {sidebarOpen && (
        <div 
          className="lg:hidden fixed inset-0 bg-black bg-opacity-50 z-40"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside className={`
        fixed top-0 left-0 h-full w-64 bg-white shadow-lg z-40 transform transition-transform duration-300 ease-in-out
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
        lg:translate-x-0 lg:static lg:transform-none
      `}>
        <div className="p-6 border-b border-stone-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-emerald-500 to-green-600 rounded-xl flex items-center justify-center">
              <Leaf className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-stone-800">ReWear</h1>
              <p className="text-sm text-stone-500">Admin Panel</p>
            </div>
          </div>
          
          {user && (
            <div className="mt-4 p-3 bg-stone-50 rounded-lg">
              <p className="text-sm font-medium text-stone-800">{user.name}</p>
              <p className="text-xs text-stone-500">{user.email}</p>
            </div>
          )}
        </div>

        <nav className="p-4">
          <ul className="space-y-2">
            {menuItems.map((item) => {
              const Icon = item.icon;
              return (
                <li key={item.id}>
                  <button
                    onClick={() => {
                      setActiveTab(item.id);
                      setSidebarOpen(false);
                    }}
                    className={`
                      w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200
                      ${activeTab === item.id 
                        ? 'bg-emerald-50 text-emerald-700 border-l-4 border-emerald-500' 
                        : 'text-stone-600 hover:bg-stone-50 hover:text-stone-800'
                      }
                    `}
                  >
                    <Icon size={20} />
                    <span className="font-medium">{item.label}</span>
                  </button>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-stone-200">
          <button
            onClick={handleSignOut}
            className="w-full flex items-center gap-3 px-4 py-3 text-stone-600 hover:bg-stone-50 hover:text-stone-800 rounded-xl transition-all duration-200 mb-4"
          >
            <LogOut size={20} />
            <span className="font-medium">Sign Out</span>
          </button>
          
          <div className="text-center text-sm text-stone-500">
            <p>© 2025 ReWear Platform</p>
            <p>Sustainable Fashion</p>
          </div>
        </div>
      </aside>
    </>
  );
}