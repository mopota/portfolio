"use client"

import { motion } from 'framer-motion'

export default function About() {
  return (
    <section id="about" className="py-20">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="space-y-6"
        >
          <h2 className="text-4xl font-bold">About Me</h2>
          <div className="w-20 h-1 bg-primary rounded-full" />
          <p className="text-lg text-zinc-400 leading-relaxed">
            I am a passionate Software Engineer with a strong foundation in mobile and web development.
            My journey in coding started with a curiosity for how things work, which evolved into
            a professional career building scalable and user-centric applications.
          </p>
          <p className="text-lg text-zinc-400 leading-relaxed">
            Currently, I focus on creating high-performance cross-platform apps using Flutter
            and exploring the integration of AI to enhance user experiences. I believe in
            writing clean, maintainable code and staying at the forefront of technology.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 20 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="glass-card p-8 relative overflow-hidden group"
        >
          <div className="grid grid-cols-2 gap-8">
            <div className="space-y-2">
              <h4 className="text-3xl font-bold text-primary">5+</h4>
              <p className="text-zinc-500">Years Experience</p>
            </div>
            <div className="space-y-2">
              <h4 className="text-3xl font-bold text-primary">20+</h4>
              <p className="text-zinc-500">Projects Completed</p>
            </div>
            <div className="space-y-2">
              <h4 className="text-3xl font-bold text-primary">10k+</h4>
              <p className="text-zinc-500">Active Users</p>
            </div>
            <div className="space-y-2">
              <h4 className="text-3xl font-bold text-primary">AI</h4>
              <p className="text-zinc-500">Enthusiast</p>
            </div>
          </div>
          <div className="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 bg-primary/10 rounded-full blur-3xl group-hover:bg-primary/20 transition-colors" />
        </motion.div>
      </div>
    </section>
  )
}
