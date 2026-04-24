import React from 'react';
import { NavLink } from 'react-router-dom';
import { 
  LayoutDashboard, 
  Activity, 
  Wallet, 
  Users, 
  Target, 
  Calendar, 
  Package, 
  Settings, 
  LogOut,
  Stethoscope
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

const navItems = [
  { icon: LayoutDashboard, label: 'Cockpit', path: '/' },
  { icon: Activity, label: 'Performance', path: '/performance' },
  { icon: Wallet, label: 'Financeiro', path: '/financial' },
  { icon: Users, label: 'Pacientes', path: '/patients' },
  { icon: Target, label: 'Sales CRM', path: '/crm' },
  { icon: Calendar, label: 'Smart Agenda', path: '/agenda' },
  { icon: Package, label: 'Estoque', path: '/inventory' },
];

export function Sidebar() {
  return (
    <aside className="w-64 bg-surface-container-low border-r border-outline-variant flex flex-col h-screen sticky top-0">
      <div className="p-6 mb-4 flex items-center gap-3">
        <div className="w-10 h-10 rounded-lg bg-primary text-on-primary flex items-center justify-center">
          <Stethoscope size={24} />
        </div>
        <div>
          <h1 className="text-lg font-black text-primary tracking-tight leading-none">DentalCore BI</h1>
          <p className="text-[10px] text-on-surface-variant font-bold uppercase tracking-wider mt-1 opacity-70">
            Executive Management
          </p>
        </div>
      </div>

      <nav className="flex-1 px-3 space-y-1">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) => cn(
              "flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200 group text-on-surface-variant hover:bg-surface-container-high hover:text-on-surface",
              isActive && "bg-white text-primary border-r-4 border-primary shadow-sm font-semibold"
            )}
          >
            <item.icon size={20} className={cn("transition-colors", "group-hover:text-primary")} />
            <span className="text-sm">{item.label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="p-3 mt-auto border-t border-outline-variant space-y-1">
        <NavLink
            to="/settings"
            className={({ isActive }) => cn(
              "flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200 group text-on-surface-variant hover:bg-surface-container-high hover:text-on-surface",
              isActive && "bg-white text-primary shadow-sm font-semibold"
            )}
          >
          <Settings size={20} />
          <span className="text-sm">Configurações</span>
        </NavLink>
        <button className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200 text-on-surface-variant hover:bg-surface-container-high hover:text-error">
          <LogOut size={20} />
          <span className="text-sm font-medium">Sair</span>
        </button>
      </div>
    </aside>
  );
}
