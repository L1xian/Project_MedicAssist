-- Insert test doctors
INSERT INTO public.doctors (name, email, password, pin_code) VALUES
('Dr. Sarah Smith', 'sarah.smith@hospital.com', '$2b$10$sK9Z.dQd7L4pM8xN2qR5veH3J1gK2hL9mN8oP7qR6sT5uV4wX3yZ0', 110001),
('Dr. James Wilson', 'james.wilson@hospital.com', '$2b$10$aB3C4dE5fG6hI7jK8lM9nO0pQ1rS2tU3vW4xY5zA6bC7dE8fG9hI', 110002),
('Dr. Emily Davis', 'emily.davis@hospital.com', '$2b$10$jK1L2mN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR', 110003),
('Dr. Michael Brown', 'michael.brown@hospital.com', '$2b$10$rS9T0uV1wX2yZ3aB4cD5eF6gH7iJ8kL9mN0oP1qR2sT3uV4wX5yZ', 110004);

-- Insert test patients
INSERT INTO public.patients (name, phone, email, password, pin_code) VALUES
('John Doe', 9876543210, 'john.doe@email.com', '$2b$10$xY6Z7aB8cD9eF0gH1iJ2kL3mN4oP5qR6sT7uV8wX9yZ0aB1cD2eF', 560001),
('Jane Smith', 9876543211, 'jane.smith@email.com', '$2b$10$eF3gH4iJ5kL6mN7oP8qR9sT0uV1wX2yZ3aB4cD5eF6gH7iJ8kL9m', 560002),
('Robert Johnson', 9876543212, 'robert.j@email.com', '$2b$10$mN0oP1qR2sT3uV4wX5yZ6aB7cD8eF9gH0iJ1kL2mN3oP4qR5sT6u', 560003),
('Lisa Anderson', 9876543213, 'lisa.anderson@email.com', '$2b$10$uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9uV0wX1yZ2aB3c', 560004),
('David Martinez', 9876543214, 'david.m@email.com', '$2b$10$cD4eF5gH6iJ7kL8mN9oP0qR1sT2uV3wX4yZ5aB6cD7eF8gH9iJ0k', 560005),
('Sarah Williams', 9876543215, 'sarah.w@email.com', '$2b$10$kL1mN2oP3qR4sT5uV6wX7yZ8aB9cD0eF1gH2iJ3kL4mN5oP6qR7s', 560006);

-- Insert test doctor-patient relationships
INSERT INTO public.doctor_patients (doctor_id, patient_id) VALUES
((SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), (SELECT id FROM public.patients WHERE name = 'John Doe')),
((SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), (SELECT id FROM public.patients WHERE name = 'Jane Smith')),
((SELECT id FROM public.doctors WHERE name = 'Dr. James Wilson'), (SELECT id FROM public.patients WHERE name = 'Robert Johnson')),
((SELECT id FROM public.doctors WHERE name = 'Dr. James Wilson'), (SELECT id FROM public.patients WHERE name = 'Lisa Anderson')),
((SELECT id FROM public.doctors WHERE name = 'Dr. Emily Davis'), (SELECT id FROM public.patients WHERE name = 'David Martinez')),
((SELECT id FROM public.doctors WHERE name = 'Dr. Michael Brown'), (SELECT id FROM public.patients WHERE name = 'Sarah Williams'));

-- Insert test appointments
INSERT INTO public.appointments (doc_id, patient_id, time) VALUES
((SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), (SELECT id FROM public.patients WHERE name = 'John Doe'), '09:30:00+00'),
((SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), (SELECT id FROM public.patients WHERE name = 'Jane Smith'), '10:15:00+00'),
((SELECT id FROM public.doctors WHERE name = 'Dr. James Wilson'), (SELECT id FROM public.patients WHERE name = 'Robert Johnson'), '14:00:00+00'),
((SELECT id FROM public.doctors WHERE name = 'Dr. Emily Davis'), (SELECT id FROM public.patients WHERE name = 'David Martinez'), '15:30:00+00');

-- Insert test patient history
INSERT INTO public.patient_history (appointment_id, patient_id, doctor_id, date, doctors_notes) VALUES
((SELECT id FROM public.appointments LIMIT 1), (SELECT id FROM public.patients WHERE name = 'John Doe'), (SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), NOW() - INTERVAL '30 days', 'Patient reported mild headaches and fatigue. Prescribed rest, hydration, and Vitamin B12 supplements. Follow-up in 2 weeks.'),
((SELECT id FROM public.appointments OFFSET 1 LIMIT 1), (SELECT id FROM public.patients WHERE name = 'Jane Smith'), (SELECT id FROM public.doctors WHERE name = 'Dr. Sarah Smith'), NOW() - INTERVAL '20 days', 'Routine annual checkup. All vitals normal (BP: 120/80, HR: 72). Continue current medications. Cholesterol levels good.'),
((SELECT id FROM public.appointments OFFSET 2 LIMIT 1), (SELECT id FROM public.patients WHERE name = 'Robert Johnson'), (SELECT id FROM public.doctors WHERE name = 'Dr. James Wilson'), NOW() - INTERVAL '15 days', 'Follow-up for blood pressure management. BP slightly elevated at 135/88. Adjusted antihypertensive medication. Referred to cardiologist for stress test.'),
(NULL, (SELECT id FROM public.patients WHERE name = 'David Martinez'), (SELECT id FROM public.doctors WHERE name = 'Dr. Emily Davis'), NOW() - INTERVAL '10 days', 'Initial consultation for chronic lower back pain. MRI ordered to rule out herniated disc. Recommended physical therapy 3x/week and pain management.');

-- Insert test blogs
INSERT INTO public.blogs (poster_id, title, content, image_url, topics) VALUES
((SELECT id FROM public.patients WHERE name = 'John Doe'), 'Living with Migraines: My Journey', 'Migraines have affected my life for over 10 years. I tried numerous treatments before finding what works. Here are 5 practical tips that significantly reduced my migraine frequency and severity...', 'https://example.com/migraine.jpg', ARRAY['health', 'wellness', 'migraines', 'pain-management']),
((SELECT id FROM public.patients WHERE name = 'Jane Smith'), 'Why Regular Checkups Save Lives', 'Many people skip their annual medical checkups, but regular visits are essential for early detection of diseases. During my last checkup, my doctor detected elevated cholesterol levels that could have led to serious complications...', 'https://example.com/checkup.jpg', ARRAY['health', 'prevention', 'checkup', 'wellness']),
((SELECT id FROM public.patients WHERE name = 'Robert Johnson'), 'Managing High Blood Pressure Naturally', 'After diagnosis with hypertension, I was determined to manage it with lifestyle changes before relying solely on medication. Diet modifications, regular exercise, and stress reduction have been game-changers for me...', 'https://example.com/bp.jpg', ARRAY['health', 'diet', 'exercise', 'blood-pressure', 'lifestyle']),
((SELECT id FROM public.patients WHERE name = 'David Martinez'), 'My Physical Therapy Recovery: Back to Life', 'Six months ago, I could barely walk due to chronic back pain. Through dedicated physical therapy and professional guidance, I have regained 90% mobility. This is my story of perseverance and recovery...', 'https://example.com/therapy.jpg', ARRAY['recovery', 'therapy', 'wellness', 'physical-therapy', 'success-story']);
