import ProjectCard from '@/components/ProjectCard'
import projects from '@/data/projects-manifest.json'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'

export default function AllProjects() {
  return (
    <div>
      <Navbar />
      <div className="max-w-7xl mx-auto px-6 py-32">
        <div className="mb-16">
          <h1 className="text-5xl font-bold mb-4">All Projects</h1>
          <p className="text-zinc-500">A comprehensive list of my software development journey.</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {projects.map((project, index) => (
            <ProjectCard key={project.id} project={project} index={index} />
          ))}
        </div>
      </div>
      <Footer />
    </div>
  )
}
