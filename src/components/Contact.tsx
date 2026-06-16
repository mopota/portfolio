"use client"

import { motion } from 'framer-motion'
import { Mail, MessageSquare, Send } from 'lucide-react'

export default function Contact() {
  return (
    <section id="contact" className="py-20">
      <div className="glass-card p-12 relative overflow-hidden">
        <div className="relative z-10 grid grid-cols-1 lg:grid-cols-2 gap-16">
          <div>
            <h2 className="text-4xl font-bold mb-6">Let's build something <span className="text-primary">extraordinary</span> together.</h2>
            <p className="text-zinc-400 mb-8 text-lg">
              I'm always open to discussing new projects, creative ideas or opportunities to be part of your visions.
            </p>

            <div className="space-y-6">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                  <Mail className="w-6 h-6" />
                </div>
                <div>
                  <p className="text-sm text-zinc-500">Email me at</p>
                  <p className="font-medium">contact@mohamedtaha.dev</p>
                </div>
              </div>
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-accent/10 flex items-center justify-center text-accent">
                  <MessageSquare className="w-6 h-6" />
                </div>
                <div>
                  <p className="text-sm text-zinc-500">Quick chat</p>
                  <p className="font-medium">Telegram: @mohamed_taha_07</p>
                </div>
              </div>
            </div>
          </div>

          <form className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <input
                type="text"
                placeholder="Name"
                className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl focus:outline-none focus:border-primary transition-colors"
              />
              <input
                type="email"
                placeholder="Email"
                className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl focus:outline-none focus:border-primary transition-colors"
              />
            </div>
            <input
              type="text"
              placeholder="Subject"
              className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl focus:outline-none focus:border-primary transition-colors"
            />
            <textarea
              rows={4}
              placeholder="Message"
              className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl focus:outline-none focus:border-primary transition-colors resize-none"
            ></textarea>
            <button className="w-full py-4 bg-primary text-white rounded-xl font-bold flex items-center justify-center gap-2 hover:bg-blue-600 transition-all">
              Send Message
              <Send className="w-4 h-4" />
            </button>
          </form>
        </div>

        <div className="absolute bottom-0 right-0 -mb-20 -mr-20 w-80 h-80 bg-primary/10 rounded-full blur-3xl -z-0" />
      </div>
    </section>
  )
}
