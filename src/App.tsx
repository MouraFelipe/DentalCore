/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { Suspense, lazy } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Layout } from './components/layout/Layout';

// Lazy load pages for performance
const Cockpit = lazy(() => import('./pages/Cockpit'));

// Placeholder pages for others
const Performance = () => <div className="p-8"><h1 className="text-2xl font-bold">Performance Page</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: Análise granular de ROI por procedimento e DRE Clínica.</p></div>;
const Financeiro = () => <div className="p-8"><h1 className="text-2xl font-bold">Módulo Financeiro</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: Controle de fluxo de caixa e integração bancária.</p></div>;
const Pacientes = () => <div className="p-8"><h1 className="text-2xl font-bold">Gestão de Pacientes</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: CRM e Prontuário Digital.</p></div>;
const CRM = () => <div className="p-8"><h1 className="text-2xl font-bold">Sales & Marketing CRM</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: Pipeline de vendas e conversão de leads.</p></div>;
const Agenda = () => <div className="p-8"><h1 className="text-2xl font-bold">Smart Agenda</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: Agendamento inteligente via IA e redução de No-shows.</p></div>;
const Estoque = () => <div className="p-8"><h1 className="text-2xl font-bold">Gestão de Estoque</h1><p className="mt-4 text-on-surface-variant italic">Módulo em desenvolvimento: Inventário automático e ordens de compra.</p></div>;
const Settings = () => <div className="p-8"><h1 className="text-2xl font-bold">Configurações</h1><p className="mt-4 text-on-surface-variant">Configure suas unidades, cadeiras e usuários administrativos.</p></div>;

export default function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={
        <div className="flex bg-surface h-screen w-full items-center justify-center">
          <div className="flex flex-col items-center gap-4">
             <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
             <p className="text-sm font-bold text-primary animate-pulse">DentalCore BI - Carregando Módulos...</p>
          </div>
        </div>
      }>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<Cockpit />} />
            <Route path="/performance" element={<Performance />} />
            <Route path="/financial" element={<Financeiro />} />
            <Route path="/patients" element={<Pacientes />} />
            <Route path="/crm" element={<CRM />} />
            <Route path="/agenda" element={<Agenda />} />
            <Route path="/inventory" element={<Estoque />} />
            <Route path="/settings" element={<Settings />} />
          </Route>
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
