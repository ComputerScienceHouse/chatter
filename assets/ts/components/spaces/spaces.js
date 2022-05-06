import './spaces.css';

function spaceTemplate(title, numConnected, maxConnections, spaceId) {
    return `
        <tr>
            <td class="space-title">
                ${title}
                <span class="badge badge-light">${numConnected} / ${maxConnections}</span>
            </td>
            <td>
                <a href="/s/${spaceId}>
                <button class="btn space-join-btn">Join</button>
                </a>
            </td>
        </tr>
    
    `;
}
