import React, { useEffect } from 'react';

function UnityGame() {
  useEffect(() => {
    const script = document.createElement('script');
    script.src = '../../public/Videogame/Build/UnityLoader.js';
    script.async = true;
    document.body.appendChild(script);

    return () => {
      document.body.removeChild(script);
    };
  }, []);

  return (
    <div className="unity-game-frame">
      <iframe
        title="Unity Game"
        src="../../public/Videogame/index.html"
        width="100%"
        height="600"
        frameBorder="0"
      />
    </div>
  );
};

export default UnityGame;