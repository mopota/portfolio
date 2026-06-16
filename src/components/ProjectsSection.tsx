"use client"

import { motion } from 'framer-motion'
import ProjectCard from './ProjectCard'
import projects from '@/data/projects-manifest.json'

export default function ProjectsSection() {
  const featuredProjects = projects.filter(p => p.featured)

  return (
    <section id="projects" className="py-20">
      <div className="flex justify-between items-end mb-16">
        <div>
          <h2 className="text-4xl font-bold mb-4">Featured Projects</h2>
          <p className="text-zinc-500">A selection of my recent works</p>
        </div>
        <a href="/projects" className="text-primary hover:underline font-medium">View All Projects</a>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {featuredProjects.map((project, index) => (
          <ProjectCard key={project.id} project={project} index={index} />
        ))}
      </div>
    </section>
  )
}
