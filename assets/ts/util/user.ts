export function getUserId() {
  const params = new URLSearchParams(window.location.search);
  return (
    params.get('spoof') ??
    document.getElementById('user-info').dataset.id ??
    '<unset>'
  );
}
