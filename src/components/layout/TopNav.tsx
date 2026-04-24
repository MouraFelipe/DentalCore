import React from 'react';
import { Search, Bell, Settings, HelpCircle, Plus } from 'lucide-react';

export function TopNav() {
  return (
    <header className="h-16 border-b border-outline-variant bg-white sticky top-0 z-40 px-6 flex items-center justify-between">
      <div className="flex-1 max-w-md">
        <div className="relative group">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant group-focus-within:text-primary transition-colors" size={18} />
          <input 
            type="text" 
            placeholder="Pesquisar pacientes, métricas..." 
            className="w-full bg-surface-container-low border border-outline-variant rounded-lg py-2 pl-10 pr-4 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all"
          />
        </div>
      </div>

      <div className="flex items-center gap-2">
        <div className="flex items-center gap-1 border-r border-outline-variant pr-4 mr-2">
          <button className="p-2 text-on-surface-variant hover:bg-surface-container rounded-full transition-all relative">
            <Bell size={20} />
            <span className="absolute top-2 right-2 w-2 h-2 bg-error rounded-full" />
          </button>
          <button className="p-2 text-on-surface-variant hover:bg-surface-container rounded-full transition-all">
            <Settings size={20} />
          </button>
          <button className="p-2 text-on-surface-variant hover:bg-surface-container rounded-full transition-all">
            <HelpCircle size={20} />
          </button>
        </div>

        <button className="bg-primary text-on-primary px-4 py-2 rounded-lg flex items-center gap-2 font-semibold text-sm hover:opacity-90 transition-opacity whitespace-nowrap shadow-sm">
          <Plus size={18} />
          <span>Adicionar Consulta</span>
        </button>

        <div className="ml-4 cursor-pointer group">
          <img 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuChXg8oANmmi4aGC3ICaXPCIxfUpQ9775NYX4OYx7ouyHvQzvDgTqgWEhhHMjRUPEkukKTHl2nn4kdpS5ro6uvLRwVS1jtXYlu1fZt0Hm2WmxU4QFiGJBCn5ptGtIyfUvSfRnac6fOskPosOuHc9NLc9Pl04yw8S_8g0JfW1QUp8Yft5yyPC6lJ5lXtwi1TS8oZEBdlavFe2zcR87fgGQPvAxE8jEI6cRco9BEoeGxQP0PfOY7IvlP8k5r6tT-gLa28P5UoVaAyuO0" 
            alt="User profile" 
            className="w-9 h-9 rounded-full object-cover border border-outline-variant group-hover:border-primary transition-colors"
            referrerPolicy="no-referrer"
          />
        </div>
      </div>
    </header>
  );
}
