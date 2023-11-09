import path from "path";
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  //@ts-ignore
  plugins: [
    react(),
    VitePWA({
      registerType: "autoUpdate",
      injectRegister: "auto",
      manifest: {
        name: "Awesome Dojo App",
        short_name: "AwesomeDojoApp",
        description: "Example",
        theme_color: "#F1C34D",
        icons: [
          {
            src: "/spaceman.png",
            sizes: "192x192",
            type: "image/png",
          },
          {
            src: "/spaceman.png",
            sizes: "512x512",
            type: "image/png",
          },
        ],
      },
    }),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
