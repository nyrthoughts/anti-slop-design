export function CleanPage() {
  return (
    <div className="transition-colors duration-200">
      <div className="animate-pulse bg-stone-200" aria-label="Loading">
        <span className="sr-only">Loading skeleton</span>
      </div>
      <div className="rounded-lg border border-stone-200">
        <h1 className="text-2xl font-medium text-stone-900">
          Your projects
        </h1>
      </div>
      <p>12 tasks across 3 repositories</p>
      <button>New project</button>
      <div className="mt-4 mb-2 gap-3">
        Consistent spacing
      </div>
    </div>
  );
}
