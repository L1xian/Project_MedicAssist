-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create tables
-- NOTE: The Flutter code in `app_repo`/`web_repo` expects a Supabase-like schema:
--   - `profiles` referencing `auth.users`
--   - `appointments` with: user_id, title, description, start_time, end_time
--   - `blogs` with: poster_id, title, content, image_url, topics, updated_at
--
-- Existing tables (doctors/patients/doctor_patients/patient_history) are kept for backward compatibility.

CREATE TABLE public.doctors (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  email character varying NOT NULL,
  password VARCHAR(255) NOT NULL,
  pin_code integer NOT NULL,
  CONSTRAINT doctors_pkey PRIMARY KEY (id)
);

CREATE TABLE public.patients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  phone bigint NOT NULL,
  email character varying,
  password VARCHAR(255) NOT NULL,
  pin_code integer NOT NULL,
  CONSTRAINT patients_pkey PRIMARY KEY (id)
);

-- Supabase auth.users -> public.profiles
CREATE TABLE public.profiles (
  id uuid NOT NULL PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  name text,
  email text,
  phone_number text
);

-- Updated appointments schema (matches app_repo queries)
-- Kept `doc_id/patient_id/time` columns as optional legacy fields.
CREATE TABLE public.appointments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  -- App expects these columns:
  user_id uuid,
  title text NOT NULL,
  description text,
  start_time timestamptz NOT NULL,
  end_time timestamptz NOT NULL,

  -- Legacy fields (optional):
  doc_id uuid,
  patient_id uuid,
  time time with time zone,

  CONSTRAINT appointments_pkey PRIMARY KEY (id),
  CONSTRAINT appointments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE,
  CONSTRAINT appointments_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES public.doctors(id) ON DELETE CASCADE,
  CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE
);

CREATE TABLE public.doctor_patients (
  doctor_id uuid NOT NULL,
  patient_id uuid NOT NULL,
  added_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT doctor_patients_pkey PRIMARY KEY (doctor_id, patient_id),
  CONSTRAINT doctor_patients_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE,
  CONSTRAINT doctor_patients_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE
);

-- Updated blogs schema (matches app_repo expectations)
CREATE TABLE public.blogs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  poster_id uuid NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  image_url text NOT NULL,
  topics text[] DEFAULT '{}'::text[],
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT blogs_pkey PRIMARY KEY (id),
  CONSTRAINT blogs_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.profiles(id) ON DELETE CASCADE
);

CREATE TABLE public.patient_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  appointment_id uuid,
  patient_id uuid NOT NULL,
  doctor_id uuid NOT NULL,
  date timestamp with time zone NOT NULL,
  doctors_notes text NOT NULL DEFAULT ''::text,
  CONSTRAINT patient_history_pkey PRIMARY KEY (id),
  CONSTRAINT patient_history_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE,
  CONSTRAINT patient_history_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE,
  CONSTRAINT patient_history_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_appointments_user_id ON public.appointments(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_start_time ON public.appointments(start_time);
CREATE INDEX IF NOT EXISTS idx_appointments_doc_id ON public.appointments(doc_id);
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON public.appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_blogs_poster_id ON public.blogs(poster_id);
CREATE INDEX IF NOT EXISTS idx_doctor_patients_patient_id ON public.doctor_patients(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_history_patient_id ON public.patient_history(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_history_doctor_id ON public.patient_history(doctor_id);

