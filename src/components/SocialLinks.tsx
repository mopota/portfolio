"use client"

import { motion } from 'framer-motion'
import { Facebook, Instagram, Linkedin, Send } from 'lucide-react'

const socials = [
  { name: 'Facebook', icon: Facebook, href: 'https://www.facebook.com/mohamed.pota.07' },
  { name: 'Instagram', icon: Instagram, href: 'https://www.instagram.com/mohamed_taha_07' },
  { name: 'Telegram', icon: Send, href: 'https://t.me/mohamed_taha_07' },
  { name: 'LinkedIn', icon: Linkedin, href: 'https://www.linkedin.com/in/mohamed-taha-79040a2a9' },
]

export default function SocialLinks() {
  return (
    <div className="fixed left-6 bottom-0 z-40 hidden lg:flex flex-col items-center gap-6">
      <div className="flex flex-col gap-6">
        {socials.map((social) => (
          <motion.a
            key={social.name}
            href={social.href}
            target="_blank"
            rel="noopener noreferrer"
            whileHover={{ y: -5, color: '#3b82f6' }}
            className="text-zinc-500 transition-colors"
          >
            <social.icon className="w-5 h-5" />
          </motion.a>
        ))}
      </div>
      <div className="w-px h-24 bg-zinc-800" />
    </div>
  )
}
