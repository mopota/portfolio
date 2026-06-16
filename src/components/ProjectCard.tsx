"use client"

import { motion } from 'framer-motion'
import { ExternalLink, Github } from 'lucide-react'
import Link from 'next/link'

export default function ProjectCard({ project, index }: { project: any, index: number }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ delay: index * 0.1 }}
      className="group glass-card overflow-hidden hover:border-primary/30 transition-all flex flex-col"
    >
      <div className="aspect-video bg-zinc-900 overflow-hidden relative">
        {project.screenshots?.[0] ? (
          <img
            src={project.screenshots[0]}
            alt={project.title}
            className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-zinc-800 font-bold text-4xl">
            {project.title.substring(0, 1)}
          </div>
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-background/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-4">
           {project.githubUrl && (
             <a href={project.githubUrl} className="p-3 bg-white/10 rounded-full hover:bg-white/20 transition-all">
                <Github className="w-6 h-6" />
             </a>
           )}
           <Link href={`/projects/${project.id}`} className="p-3 bg-primary rounded-full hover:bg-blue-600 transition-all">
              <ExternalLink className="w-6 h-6" />
           </Link>
        </div>
      </div>

      <div className="p-6 flex-1 flex flex-col">
        <div className="flex justify-between items-start mb-4">
          <h3 className="text-2xl font-bold group-hover:text-primary transition-colors">{project.title}</h3>
          <span className="text-xs px-2 py-1 rounded bg-zinc-800 text-zinc-400">{project.category}</span>
        </div>
        <p className="text-zinc-400 mb-6 line-clamp-2">{project.shortDescription}</p>
        <div className="flex flex-wrap gap-2 mt-auto">
          {project.technologies.slice(0, 3).map((tech: string) => (
            <span key={tech} className="text-[10px] px-2 py-1 rounded-md bg-white/5 border border-white/10 text-zinc-500">
              {tech}
            </span>
          ))}
          {project.technologies.length > 3 && (
            <span className="text-[10px] px-2 py-1 text-zinc-600">+{project.technologies.length - 3} more</span>
          )}
        </div>
      </div>
    </motion.div>
  )
}
