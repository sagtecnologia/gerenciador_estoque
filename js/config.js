// =====================================================
// CONFIGURAÇÃO DO SUPABASE
// =====================================================

// IMPORTANTE: Substitua com suas credenciais do Supabase
const SUPABASE_URL = 'https://somxgcrolxtwrgpdcdyf.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_rYA4VlwIEQVtnKhVMO0NXQ_vlBD2Lxw';

// Inicializar cliente Supabase e exportar para uso global
// A biblioteca Supabase CDN expõe o namespace em window.supabase
const { createClient } = window.supabase;
window.supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
