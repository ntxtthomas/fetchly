// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Clickable table rows with hover and click feedback
document.addEventListener('DOMContentLoaded', function() {
  const rows = document.querySelectorAll('tr[data-url]');

  rows.forEach(row => {
    // Hover feedback
    row.addEventListener('mouseenter', function() {
      this.style.backgroundColor = '#f8f9fa';
    });
    
    row.addEventListener('mouseleave', function() {
      if (!this.classList.contains('clicked')) {
        this.style.backgroundColor = '';
      }
    });
    
    // Click feedback
    row.addEventListener('click', function() {
      // Check if URL exists
      if (!this.dataset.url) {
        console.error('No data-url found on this row!');
        return;
      }
      // Visual feedback
      this.classList.add('clicked');
      // Brief delay for visual confirmation
      setTimeout(() => {
        window.location.href = this.dataset.url;
      }, 150);
    });
  });
});
