import { notFound } from 'next/navigation'
import projects from '@/data/projects-manifest.json'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'
import { Github, Globe, Download, ChevronLeft } from 'lucide-react'
import Link from 'next/link'

export function generateStaticParams() {
  return projects.map((project) => ({
    id: project.id,
  }))
}

export default function ProjectDetails({ params }: { params: { id: string } }) {
  const project = projects.find((p) => p.id === params.id)

  if (!project) {
    notFound()
  }

  return (
    <div>
      <Navbar />
      <div className="max-w-7xl mx-auto px-6 py-32">
        <Link
          href="/projects"
          className="inline-flex items-center gap-2 text-zinc-500 hover:text-white mb-12 transition-colors"
        >
          <ChevronLeft className="w-4 h-4" />
          Back to projects
        </Link>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 mb-20">
          <div>
            <div className="flex items-center gap-4 mb-6">
               {project.icon ? (
                 <img src={project.icon} alt={project.title} className="w-16 h-16 rounded-2xl" />
               ) : (
                 <div className="w-16 h-16 rounded-2xl bg-primary/20 flex items-center justify-center text-primary text-2xl font-bold">
                    {project.title.substring(0, 1)}
                 </div>
               )}
               <div>
                 <h1 className="text-4xl font-bold">{project.title}</h1>
                 <p className="text-zinc-500">{project.category} • Version {project.version}</p>
               </div>
            </div>

            <p className="text-xl text-zinc-300 leading-relaxed mb-8">
              {project.description}
            </p>

            <div className="flex flex-wrap gap-4 mb-12">
               {project.downloadUrl && (
                 <a
                   href={project.downloadUrl}
                   className="px-8 py-3 bg-primary text-white rounded-xl font-bold flex items-center gap-2 hover:bg-blue-600 transition-all"
                 >
                   <Download className="w-5 h-5" />
                   Download App
                 </a>
               )}
               {project.githubUrl && (
                 <a
                   href={project.githubUrl}
                   className="px-8 py-3 bg-white/5 border border-white/10 rounded-xl font-bold flex items-center gap-2 hover:bg-white/10 transition-all"
                 >
                   <Github className="w-5 h-5" />
                   Source Code
                 </a>
               )}
            </div>

            <div>
              <h3 className="text-xl font-bold mb-4">Technologies Used</h3>
              <div className="flex flex-wrap gap-2">
                {project.technologies.map((tech: string) => (
                  <span key={tech} className="px-4 py-2 rounded-lg bg-zinc-900 border border-white/5 text-zinc-400 text-sm">
                    {tech}
                  </span>
                ))}
              </div>
            </div>
          </div>

          <div className="space-y-8">
            <h3 className="text-xl font-bold">Gallery</h3>
            <div className="grid grid-cols-1 gap-6">
              {project.screenshots.length > 0 ? (
                project.screenshots.map((src: string, i: number) => (
                  <img
                    key={i}
                    src={src}
                    alt={`${project.title} Screenshot ${i + 1}`}
                    className="w-full rounded-2xl border border-white/10 shadow-2xl"
                  />
                ))
              ) : (
                <div className="aspect-video glass-card flex items-center justify-center text-zinc-700 italic">
                  No screenshots available yet.
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  )
}
