import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://zcnahovsncdywixkwkur.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpjbmFob3ZzbmNkeXdpeGt3a3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIyODQ1MjMsImV4cCI6MjA2Nzg2MDUyM30.M2TyKMTgDsppSZn2IzTgETDLRdmKiB-ByDy-73snYIQ'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
