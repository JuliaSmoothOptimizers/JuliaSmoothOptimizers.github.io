const tutorialInput = document.getElementById('tutorial-input');
const tutorialsOutput = document.getElementById('tutorials-output');
const prepath = document.getElementById('prepath').textContent;

active_tag = '';

function format_tag(tag) {
  return `<span class="tag is-light is-link">${tag}</span>`
}

function format_pkg(pkg, add_id=false) {
  return `<span class="tag is-light is-danger">${pkg}</span>`
}

function format_tutorial(t) {
  tags = ''
  for (tag of t.tags) {
    tags += format_tag(tag)
  }
  pkgs = ''
  for (pkg of t.pkgs) {
    pkgs += format_pkg(pkg)
  }

  link = t.link
  // link can be internal (/etc) or external (http://some.lnk)
  // prepath can be "" (local and gh-pages) or "preview/PRXX" (preview)
  // if the link is internal and it is a preview mode, we have to fix it adding a / before
  const isInternal = t.link.slice(0,4) != 'http'
  const hasPrepath = prepath != ""
  if (hasPrepath && isInternal) {
    link = '/' + prepath + link
  }
  console.log(link)
  console.log(t.link)
  return `<div class="news-item">
    <a href="${link}">
      <span class="is-size-4 has-text-primary">${t.title}</span>
      <br>
      <p class="has-text-grey-dark is-size-6">${t.short}</p>
    </a>
    <div class="tags">
      ${tags}
      ${pkgs}
    </div>
  </div>`
}

function tags_click(e) {
  out = ''
  for (t of data) {
    if (t.tags.includes(e)) {
      out += format_tutorial(t)
    }
  }
  tutorialsOutput.innerHTML = out;
}

function pkgs_click(e) {
  out = ''
  for (t of data) {
    if (t.pkgs.includes(e)) {
      out += format_tutorial(t)
    }
  }
  tutorialsOutput.innerHTML = out;
}

function list_tutorials() {
  out = ''
  for (t of data) {
    out += format_tutorial(t)
  }
  tutorialsOutput.innerHTML = out;
}

function toggle_show_tags() {
  tag_div = document.getElementById('tags');
  tag_div.classList.toggle('is-height-zero');
  list_tutorials()
  show_tag_btn = document.getElementById('show-tags-btn');
  if (show_tag_btn.children[1].innerHTML == 'Show tags') {
    show_tag_btn.children[1].innerHTML = 'Hide tags';
  } else {
    show_tag_btn.children[1].innerHTML = 'Show tags';
  }
}

window.onload = list_tutorials()
