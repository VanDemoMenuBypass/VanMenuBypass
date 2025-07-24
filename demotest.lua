// AutoGrowGarden.tsx
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle2, Loader2, Leaf } from "lucide-react";

const allSeeds = [
  { id: 1, name: "Cà chua", emoji: "🍅" },
  { id: 2, name: "Cà rốt", emoji: "🥕" },
  { id: 3, name: "Bí ngô", emoji: "🎃" },
  { id: 4, name: "Dâu tây", emoji: "🍓" },
];

type Plant = {
  id: number;
  name: string;
  emoji: string;
  growth: number;
  zenUsed: number;
};

export default function AutoGrowGarden() {
  const [username, setUsername] = useState("");
  const [garden, setGarden] = useState<Plant[]>([]);
  const [autoMode, setAutoMode] = useState(false);

  const startAutoGrow = () => {
    if (!username) return alert("IMRICK IS KING);
    // Gieo toàn bộ hạt
    const planted = allSeeds.map((s) => ({
      ...s,
      growth: 0,
      zenUsed: 0,
    }));
    setGarden(planted);
    setAutoMode(true);
  };

  const stopAutoGrow = () => {
    setAutoMode(false);
  };

  // Zen event: tăng growth đều đặn
  useEffect(() => {
    if (!autoMode) return;

    const zenInterval = setInterval(() => {
      setGarden((prev) =>
        prev.map((p) =>
          p.growth < 100
            ? {
                ...p,
                growth: Math.min(100, p.growth + 20),
                zenUsed: p.zenUsed + 1,
              }
            : p
        )
      );
    }, 3000);

    return () => clearInterval(zenInterval);
  }, [autoMode]);

  return (
    <div className="max-w-3xl mx-auto p-6 space-y-6">
      <h1 className="text-3xl font-bold text-center">🌼 Auto Grow a Garden</h1>

      <div className="flex gap-2 items-center justify-center">
        <Input
          placeholder="Nhập tên của bạn..."
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          disabled={autoMode}
        />
        {!autoMode ? (
          <Button onClick={startAutoGrow}>Bắt đầu 🌱</Button>
        ) : (
          <Button variant="destructive" onClick={stopAutoGrow}>
            Dừng ⛔
          </Button>
        )}
      </div>

      {autoMode && (
        <div className="text-center text-muted-foreground">
          👤 Đang chạy chế độ tự động cho: <strong>{username}</strong>
        </div>
      )}

      <div className="grid md:grid-cols-2 gap-4">
        {garden.map((plant) => (
          <Card key={plant.id}>
            <CardContent className="p-4 space-y-2">
              <div className="flex justify-between items-center">
                <span className="text-3xl">{plant.emoji}</span>
                <span className="font-semibold">{plant.name}</span>
              </div>

              <div className="text-sm">Tăng trưởng: {plant.growth}%</div>
              <div className="text-sm">
                Zen dùng: {plant.zenUsed} {plant.growth >= 100 && "✅"}
              </div>

              {plant.growth >= 100 ? (
                <div className="text-green-600 flex items-center gap-1">
                  <CheckCircle2 className="w-4 h-4" /> Đã hoàn thành
                </div>
              ) : (
                <div className="text-blue-500 flex items-center gap-1">
                  <Loader2 className="animate-spin w-4 h-4" />
                  Đang thiền Zen...
                </div>
              )}
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}