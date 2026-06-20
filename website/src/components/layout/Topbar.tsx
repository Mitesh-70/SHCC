import { useAuth } from '../../context/AuthContext';

interface TopbarProps {
  title?: string;
  subtitle?: string;
}

export default function Topbar({ title, subtitle }: TopbarProps) {
  const { user } = useAuth();

  const greeting = (() => {
    const h = new Date().getHours();
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  })();

  const displayTitle = title ?? `${greeting}, ${user?.name?.split(' ')[0] ?? 'User'}! 👋`;
  const displaySub = subtitle ?? "Here's what's happening with your business today.";

  return (
    <header className="flex items-start justify-between px-6 pt-6 pb-2">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">{displayTitle}</h1>
        <p className="text-sm text-gray-500 mt-0.5">{displaySub}</p>
      </div>
    </header>
  );
}
