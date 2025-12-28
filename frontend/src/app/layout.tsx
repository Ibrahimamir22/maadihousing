import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Maadi Housing | Coming Soon',
  description: 'Premium real estate solutions in Maadi, Cairo. Find your perfect home with Maadi Housing - launching soon.',
  keywords: ['maadi', 'housing', 'real estate', 'cairo', 'egypt', 'apartments', 'homes'],
  authors: [{ name: 'Maadi Housing' }],
  openGraph: {
    title: 'Maadi Housing | Coming Soon',
    description: 'Premium real estate solutions in Maadi, Cairo. Find your perfect home with Maadi Housing.',
    url: 'https://maadihousing.com',
    siteName: 'Maadi Housing',
    type: 'website',
    locale: 'en_US',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Maadi Housing | Coming Soon',
    description: 'Premium real estate solutions in Maadi, Cairo.',
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body className="grain-overlay">
        {children}
      </body>
    </html>
  )
}

