const hoverToggle = (event) => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const visibility = event.type === 'mouseover' ? 'visible' : 'hidden'
  const id = segment.id.split('-')
  document.getElementById(`${id[0]}-inspect-${id[2]}`).style.visibility = visibility
}

document.addEventListener('mouseover', hoverToggle)
document.addEventListener('mouseout', hoverToggle)
