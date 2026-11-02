export function BadPage() {
  return (
    <div className="transition-all duration-300">
      <div className="animate-pulse bg-purple-500">Featured items</div>
      <div className="hover:scale-105 rounded-xl shadow-lg">
        <h1 className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
          Build beautiful products
        </h1>
      </div>
      <p>Welcome back 👋</p>
      <p>🚀 Supercharge your workflow!</p>
      <button>Unlock Premium</button>
      <div className="mt-[13px] mb-[7px] gap-[11px]">
        Arbitrary spacing everywhere
      </div>
    </div>
  );
}
