import React from 'react';
import { 
  TrendingUp, 
  TrendingDown, 
  Users, 
  Armchair, 
  AlertTriangle,
  Clock,
  Package,
  Wallet
} from 'lucide-react';
import { Card, CardHeader, CardTitle } from '@/src/components/ui/Card';
import { cn } from '@/src/lib/utils';
import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  AreaChart,
  Area
} from 'recharts';

const chartData = [
  { name: 'Sem 1', value: 45 },
  { name: 'Sem 2', value: 52 },
  { name: 'Sem 3', value: 78 },
  { name: 'Sem 4', value: 85 },
];

export default function Cockpit() {
  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex justify-between items-end">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Visão Geral da Clínica</h2>
          <p className="text-on-surface-variant">Métricas atualizadas em tempo real</p>
        </div>
        <div className="text-right">
          <p className="text-[10px] font-bold text-on-surface-variant uppercase tracking-widest">Última atualização</p>
          <p className="text-sm font-semibold text-on-surface">Hoje, 14:32</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="flex flex-col justify-between overflow-hidden relative">
          <div className="absolute top-0 left-0 w-1 h-full bg-primary" />
          <CardHeader>
            <CardTitle className="text-base text-on-surface-variant">Faturamento Hoje</CardTitle>
            <div className="p-2 bg-primary-fixed rounded-lg text-primary">
              <TrendingUp size={18} />
            </div>
          </CardHeader>
          <div>
            <p className="text-3xl font-black text-primary">R$ 12.450,00</p>
            <div className="flex items-center mt-2 gap-1 text-secondary text-xs font-bold">
              <TrendingUp size={14} />
              <span>+15% vs ontem</span>
            </div>
          </div>
        </Card>

        <Card className="flex flex-col justify-between overflow-hidden relative">
           <div className="absolute top-0 left-0 w-1 h-full bg-tertiary" />
          <CardHeader>
            <CardTitle className="text-base text-on-surface-variant">Ocupação Atual (%)</CardTitle>
            <div className="p-2 bg-tertiary-fixed rounded-lg text-tertiary">
              <Armchair size={18} />
            </div>
          </CardHeader>
          <div>
            <p className="text-3xl font-black text-on-surface">82%</p>
            <div className="flex items-center mt-2 gap-1 text-error text-xs font-bold">
              <TrendingDown size={14} />
              <span>-3% vs média mensal</span>
            </div>
          </div>
        </Card>

        <Card className="flex flex-col justify-between overflow-hidden relative">
           <div className="absolute top-0 left-0 w-1 h-full bg-secondary" />
          <CardHeader>
            <CardTitle className="text-base text-on-surface-variant">Novos Pacientes (Semana)</CardTitle>
            <div className="p-2 bg-secondary-container rounded-lg text-secondary">
              <Users size={18} />
            </div>
          </CardHeader>
          <div>
            <p className="text-3xl font-black text-on-surface">24</p>
            <div className="flex items-center mt-2 gap-1 text-secondary text-xs font-bold">
              <TrendingUp size={14} />
              <span>+8% vs semana anterior</span>
            </div>
          </div>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        <Card className="lg:col-span-8">
          <CardHeader>
            <CardTitle>Próximos Atendimentos</CardTitle>
            <button className="text-primary text-xs font-bold hover:underline">Ver Agenda Completa</button>
          </CardHeader>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-outline-variant">
                  <th className="text-left py-3 text-[10px] font-black text-on-surface-variant uppercase tracking-widest">Paciente</th>
                  <th className="text-left py-3 text-[10px] font-black text-on-surface-variant uppercase tracking-widest">Horário</th>
                  <th className="text-left py-3 text-[10px] font-black text-on-surface-variant uppercase tracking-widest">Procedimento</th>
                  <th className="text-left py-3 text-[10px] font-black text-on-surface-variant uppercase tracking-widest">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-outline-variant">
                {[
                  { name: "Ana Maria Silva", time: "14:00", proc: "Limpeza (Profilaxia)", status: "Confirmado", img: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop" },
                  { name: "Ricardo Oliveira", time: "15:30", proc: "Restauração Resinosa", status: "Em Espera", img: "https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=150&auto=format&fit=crop" },
                  { name: "Juliana Santos", time: "16:15", proc: "Consulta Avaliação", status: "Confirmado", img: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop" },
                ].map((item, i) => (
                  <tr key={i} className="group hover:bg-surface-container-low transition-colors">
                    <td className="py-4">
                      <div className="flex items-center gap-3">
                        <img src={item.img} alt={item.name} className="w-8 h-8 rounded-full object-cover" referrerPolicy="no-referrer" />
                        <span className="text-sm font-bold text-on-surface">{item.name}</span>
                      </div>
                    </td>
                    <td className="py-4 text-sm font-medium text-on-surface-variant">{item.time}</td>
                    <td className="py-4 text-sm text-on-surface-variant">{item.proc}</td>
                    <td className="py-4">
                      <span className={cn(
                        "text-[10px] font-black px-2 py-1 rounded-full uppercase tracking-tighter",
                        item.status === "Confirmado" ? "bg-secondary-container text-on-secondary-container" : "bg-surface-container-highest text-on-surface-variant"
                      )}>
                        {item.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>

        <Card className="lg:col-span-4 bg-surface-container-low border-none">
          <CardHeader>
            <div className="flex items-center gap-2">
              <AlertTriangle size={18} className="text-error" />
              <CardTitle>Alertas Críticos</CardTitle>
            </div>
            <span className="bg-error-container text-on-error-container px-2 py-0.5 rounded-full text-[10px] font-bold">3</span>
          </CardHeader>
          <div className="space-y-3">
             <div className="p-3 bg-white rounded-lg border border-outline-variant flex gap-3 hover:shadow-sm transition-shadow cursor-pointer">
               <Package className="text-error shrink-0" size={18} />
               <div>
                  <p className="text-sm font-bold text-on-surface">Estoque Baixo</p>
                  <p className="text-xs text-on-surface-variant mt-0.5">Resina A2, Luvas P, Sugadores</p>
               </div>
             </div>
             <div className="p-3 bg-white rounded-lg border border-outline-variant flex gap-3 hover:shadow-sm transition-shadow cursor-pointer">
               <Clock className="text-primary shrink-0" size={18} />
               <div>
                  <p className="text-sm font-bold text-on-surface">Cadeiras Ociosas</p>
                  <p className="text-xs text-on-surface-variant mt-0.5">Dra. Silva e Dr. Costa sem agenda 14h-16h</p>
               </div>
             </div>
             <div className="p-3 bg-white rounded-lg border border-outline-variant flex gap-3 hover:shadow-sm transition-shadow cursor-pointer">
               <Wallet className="text-on-surface-variant shrink-0" size={18} />
               <div>
                  <p className="text-sm font-bold text-on-surface">Faturas em Atraso</p>
                  <p className="text-xs text-on-surface-variant mt-0.5">5 faturas superam 30 dias. Ação necessária.</p>
               </div>
             </div>
          </div>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div>
            <CardTitle>Receita vs Previsão</CardTitle>
            <p className="text-sm text-on-surface-variant">Acompanhamento Diário - Mês Atual</p>
          </div>
          <select className="bg-surface-container border border-outline-variant rounded-md px-3 py-1 text-xs font-semibold focus:outline-none focus:ring-1 focus:ring-primary">
            <option>Novembro 2023</option>
            <option>Outubro 2023</option>
          </select>
        </CardHeader>
        <div className="h-[300px] w-full mt-4">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={chartData}>
              <defs>
                <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#003178" stopOpacity={0.1}/>
                  <stop offset="95%" stopColor="#003178" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e1e3e4" />
              <XAxis dataKey="name" fontSize={10} axisLine={false} tickLine={false} />
              <YAxis fontSize={10} axisLine={false} tickLine={false} />
              <Tooltip 
                contentStyle={{ borderRadius: '8px', border: '1px solid #c3c6d4', fontSize: '12px' }}
              />
              <Area type="monotone" dataKey="value" stroke="#003178" strokeWidth={2} fillOpacity={1} fill="url(#colorValue)" />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </Card>
    </div>
  );
}
