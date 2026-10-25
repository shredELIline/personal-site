const button = document.querySelector('.copy-email');
button.addEventListener('click', async () => {
  const status = document.getElementById('copy-status');
  try {
    const email = 'elizaralexeydev777@gmail.com';
    if (window.isSecureContext && navigator.clipboard) {
      await navigator.clipboard.writeText(email);
    } else {
      const field = document.createElement('textarea');
      field.value = email;
      field.readOnly = true;
      field.style.cssText = 'position:fixed;left:-9999px;top:0';
      document.body.append(field);
      try {
        field.select();
        if (!document.execCommand('copy')) throw new Error('Copy unavailable');
      } finally {
        field.remove();
        button.focus({ preventScroll: true });
      }
    }
    button.textContent = 'Email copied ✓';
    status.textContent = 'Email address copied to clipboard.';
    setTimeout(() => { button.textContent = 'Copy email ⧉'; }, 2400);
  } catch {
    status.textContent = 'Copy this address: elizaralexeydev777@gmail.com';
    button.textContent = 'elizaralexeydev777@gmail.com';
  }
});
