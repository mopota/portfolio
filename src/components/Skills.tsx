"use client"

import { motion } from 'framer-motion'

const skills = [
  { name: 'Flutter', category: 'Mobile' },
  { name: 'Dart', category: 'Language' },
  { name: 'Firebase', category: 'Backend' },
  { name: 'Node.js', category: 'Backend' },
  { name: 'JavaScript', category: 'Language' },
  { name: 'HTML/CSS', category: 'Frontend' },
  { name: 'Python', category: 'Language' },
  { name: 'Git/GitHub', category: 'Tools' },
  { name: 'REST APIs', category: 'Networking' },
  { name: 'AI/ML', category: 'Specialty' },
  { name: 'Android', category: 'Platform' },
]

export default function Skills() {
  return (
    <section id="skills" className="py-20">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold mb-4">My Skills</h2>
        <p className="text-zinc-500">Technologies I use to bring ideas to life</p>
      </div>

      <div className="flex flex-wrap justify-center gap-4">
        {skills.map((skill, index) => (
          <motion.div
            key={skill.name}
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            whileHover={{ y: -5, scale: 1.05 }}
            transition={{ delay: index * 0.05 }}
            className="px-6 py-3 glass-card flex items-center gap-3 hover:border-primary/50 transition-all cursor-default"
          >
            <span className="font-medium">{skill.name}</span>
            <span className="text-[10px] uppercase tracking-widest text-zinc-500">{skill.category}</span>
          </motion.div>
        ))}
      </div>
    </section>
  )
}
