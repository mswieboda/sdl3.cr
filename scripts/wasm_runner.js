const puppeteer = require('puppeteer');

(async () => {
  const url = process.argv[2] || 'http://localhost:8000/build/hello.html';
  console.log(`Automation: Launching browser for ${url}...`);

  const browser = await puppeteer.launch({
    headless: "new",
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  const page = await browser.newPage();

  // Redirect console logs
  page.on('console', msg => {
    const type = msg.type();
    const text = msg.text();
    if (type === 'error') {
      console.error(`[BROWSER ERROR] ${text}`);
    } else {
      console.log(`[BROWSER LOG] ${text}`);
    }
  });

  // Catch page crashes or errors
  page.on('error', err => console.error(`[PAGE CRASH] ${err}`));
  page.on('pageerror', err => console.error(`[PAGE ERROR] ${err}`));

  try {
    await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });

    // Let it run for 5 seconds to collect logs
    console.log("Automation: Collecting logs for 5 seconds...");
    await new Promise(resolve => setTimeout(resolve, 5000));

  } catch (e) {
    console.error(`Automation: Failed to load page: ${e.message}`);
  } finally {
    console.log("Automation: Closing browser.");
    await browser.close();
  }
})();
