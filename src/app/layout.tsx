import type { Metadata } from 'next'
import { Inter, Tajawal } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/ThemeProvider'

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })
const tajawal = Tajawal({
  subsets: ['arabic'],
  weight: ['400', '500', '700'],
  variable: '--font-tajawal'
})

export const metadata: Metadata = {
  title: 'Mohamed Taha | Software Engineer',
  description: 'Portfolio of Mohamed Taha - Flutter Developer, AI Enthusiast & Software Engineer',
  keywords: ['Mohamed Taha', 'Software Engineer', 'Flutter Developer', 'Mobile App Developer', 'AI Enthusiast'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} ${tajawal.variable} font-sans bg-background text-foreground selection:bg-primary/30`}>
        <ThemeProvider attribute="class" defaultTheme="dark">
          <div className="fixed inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(17,24,39,1)_0%,rgba(0,0,0,1)_100%)] -z-10" />
          <div className="fixed inset-0 bg-[url('/grid.svg')] bg-center [mask-image:linear-gradient(180deg,white,rgba(255,255,255,0))] -z-10 opacity-20" />
          <main className="min-h-screen relative">
            {children}
          </main>
        </ThemeProvider>
      </body>
    </html>
  )
}
