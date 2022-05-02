import styles from './Hero.module.css';
import React from 'react';
import clsx from 'clsx';

export default function IntroBanner({children}) {
  return (
    <header id="hero" className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">
        {children}
        </h1>
      </div>
    </header>
  );
}

