{
  description = "Vibesteroids development environment with HTTPS and hot reload";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # HTTPS development server script
        devServer = pkgs.writeShellScriptBin "dev-server" ''
          set -e
          
          echo "🚀 Setting up Vibesteroids HTTPS development server..."
          
          # Generate self-signed certificate if it doesn't exist
          if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ]; then
            echo "📜 Generating SSL certificate..."
            ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
              -subj "/C=US/ST=Dev/L=Local/O=Vibesteroids/CN=localhost" 2>/dev/null
            echo "✅ SSL certificate generated"
          fi
          
          # Start the HTTPS server with hot reload
          echo "🌐 Starting HTTPS server at https://localhost:8443"
          echo "📁 Serving files from: src/"
          echo "🔄 Hot reload enabled - changes will refresh the browser"
          echo ""
          echo "Press Ctrl+C to stop the server"
          echo ""
          
          # Open browser after a short delay
          (sleep 2 && ${pkgs.python3}/bin/python3 -c "
import webbrowser
import time
time.sleep(1)
webbrowser.open('https://localhost:8443/asteroids.html')
print('🌍 Browser opened to https://localhost:8443/asteroids.html')
          " &) &
          
          # Start the server with hot reload using browser-sync
          ${pkgs.nodePackages.browser-sync}/bin/browser-sync start \
            --server "src" \
            --https \
            --port 8443 \
            --files "src/*.html,src/*.js,src/*.css" \
            --no-open \
            --no-notify \
            --logLevel "silent"
        '';
        
        # Alternative Python-based server for fallback
        pythonServer = pkgs.writeShellScriptBin "python-dev-server" ''
          set -e
          
          echo "🐍 Starting Python HTTPS development server..."
          
          # Generate certificate if needed
          if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ]; then
            echo "📜 Generating SSL certificate..."
            ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
              -subj "/C=US/ST=Dev/L=Local/O=Vibesteroids/CN=localhost" 2>/dev/null
          fi
          
          # Open browser
          (sleep 2 && ${pkgs.python3}/bin/python3 -c "
import webbrowser
webbrowser.open('https://localhost:8443/asteroids.html')
          " &) &
          
          # Start Python HTTPS server
          cd src && ${pkgs.python3}/bin/python3 -c "
import http.server
import ssl
import socketserver

PORT = 8443

class Handler(http.server.SimpleHTTPRequestHandler):
    pass

with socketserver.TCPServer(('localhost', PORT), Handler) as httpd:
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain('../cert.pem', '../key.pem')
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    
    print('🌐 HTTPS Server running at https://localhost:' + str(PORT))
    print('Press Ctrl+C to stop')
    httpd.serve_forever()
          "
        '';
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            pnpm
            openssl
            python3
            nodePackages.browser-sync
            
            # Custom development server scripts
            devServer
            pythonServer
          ];

          shellHook = ''
            echo "🎮 Vibesteroids HTTPS Development Environment"
            echo "=============================================="
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo "pnpm version: $(pnpm --version)"
            echo "OpenSSL version: $(openssl version)"
            echo ""
            echo "🚀 Available commands:"
            echo "  dev-server          - Start HTTPS server with hot reload (recommended)"
            echo "  python-dev-server   - Start Python HTTPS server (fallback)"
            echo ""
            echo "💡 Run 'dev-server' to start development with HTTPS and auto-reload!"
            echo "   The server will automatically open your browser to the game."
            echo ""
          '';
        };
      });
}
