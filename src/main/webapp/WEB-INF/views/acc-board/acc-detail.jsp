<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>

    <!-- reset -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reset-css@5.0.1/reset.min.css">

    <!-- fontawesome css: https://fontawesome.com -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css">

    <!-- https://linearicons.com/free#cdn -->
    <link rel="stylesheet" href="https://cdn.linearicons.com/free/1.0.0/icon-font.min.css">

    <!-- bootstrap css -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- bootstrap js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" defer></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
        }
        #wrap {
            width: 60%;
            max-width: 800px;
            background-color: #fff;
            margin: 0 auto;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            height: 100vh;
        }
        #wrap p {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }
        #wrap input[type="text"], #wrap #content {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f8f8f8;
        }
        #inner-wrapper {
            width: 100%;
            padding: 20px;
        }
        #inner-wrapper .content {
            font-size: 0.9em;
        }
        #inner-wrapper .text {
            margin-bottom: 30px;
        }
        .card-img {
            height: 150px;
            background-color: #00CE7B;
        }
        #title .main-title{
            font-size: 1.5em;
            font-weight: bold;
        }
        #title .sub-title{
            font-size: 0.9em;
            color: #999;
            padding: 10px 0px 30px;
        }
        #detail-travel .title {
            font-size: 0.9em;
            font-weight: bold;
        }
        #detail-travel .travel-info {
            margin-top: 10px;
            font-size: 0.9em;
            background-color: #f8f8f8;
            padding: 15px 10px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        #detail-travel .travel-info .fas {
            color: #999;
        }
        #detail-travel {
            font-size: 0.9em;
        }
        .buttons {
            margin: 20px auto;
        }
        .buttons .edit-btn, .buttons .list-btn {
            margin-right: 10px;
            margin-top: 10px;
        }
        .reaction-buttons button {
            background-color: transparent;
            color: #000;
            border: 2px solid #00CE7B;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        .reaction-buttons button.active {
            background-color: #00CE7B;
            color: #fff;
        }

    </style>

</head>
<body>

    <div id="wrap" class="form-container" data-bno="${abd.boardId}">
        <div class="card-img">
            <img src="#" alt="대표이미지">
        </div>
        <div id="inner-wrapper">
            <div id="title">
                <div class="main-title">
                    ${abd.title}
                </div>
                <div class="sub-title">
                    <scan class="view-count">조회수 ${abd.viewCount}</scan>
                </div>
            </div>
            <div id="detail-travel">
                <p class="title">여행 일정</p>
                <div class="travel-info">
                    <div class="travel-period">
                        <i class="fas fa-calendar"></i> &nbsp;${abd.startDate} - ${abd.endDate}
                    </div>
                    <div class="travel-destination">
                        <i class="fas fa-map-marker-alt"></i> &nbsp;장소
                    </div>

                </div>
                <p class="content">여행 소개</p>
                <div class="text">
                    ${abd.content}
                </div>
            </div>

            <div class="buttons">
                <div class="reaction-buttons">
                    <button id="bookmark-btn" class="bookmark-button ${bookmark?active:''}}">
                        <i class="far fa-bookmark"></i>
                        <i class="fas fa-bookmark" style="display: none;"></i>
                    </button>
                </div>
                <button class="edit-btn btn btn-secondary" type="button"
                        onclick="window.location.href='/acc-board/modify?bno=${abd.boardId}'">수정
                </button>
                <button class="list-btn btn btn-secondary" type="button" onclick="window.location.href='${ref}'">목록
                </button>
            </div>

            <%--  댓글영역  --%>
            <div>댓글</div>

        </div>
    </div>

        <script>
            // 페이지 로드 시 북마크 상태 확인 및 버튼 업데이트
            document.addEventListener('DOMContentLoaded', async function () {
                const bno = document.getElementById('wrap').dataset.bno;

                const res = await fetch(`/acc-board/bookmark/status?boardId=\${bno}`);
                const isBookmarked = await res.json();
                updateBookmarkButton(isBookmarked);
            });

            // 북마크 요청을 보내는 함수
            async function toggleBookmark() {
                const bno = document.getElementById('wrap').dataset.bno;
                console.log("bno: ", bno);
                const res = await fetch(`/acc-board/bookmark?boardId=\${bno}`, {
                    method: 'GET'
                });

                if (res.status === 403) {
                    alert('로그인이 필요합니다.');
                    window.location.href = '/sign-in';  // 로그인 페이지로 리다이렉트
                    return;
                }

                if (!res.ok) {
                    const errorMsg = await res.text();
                    alert(errorMsg);
                    return;
                }

                const { bookmarkCount, userBookmark } = await res.json();
                updateBookmarkButton(userBookmark);
            }

            // 북마크 버튼 스타일 업데이트 함수
            function updateBookmarkButton(userBookmark) {
                const bookmarkBtn = document.getElementById('bookmark-btn');
                const farIcon = bookmarkBtn.querySelector('.far.fa-bookmark');
                const fasIcon = bookmarkBtn.querySelector('.fas.fa-bookmark');

                if (userBookmark) {
                    bookmarkBtn.classList.add('active');
                    farIcon.style.display = 'none';
                    fasIcon.style.display = 'inline';
                } else {
                    bookmarkBtn.classList.remove('active');
                    farIcon.style.display = 'inline';
                    fasIcon.style.display = 'none';
                }
            }

            // 북마크 버튼 클릭 이벤트 리스너 추가
            document.getElementById('bookmark-btn').addEventListener('click', toggleBookmark);
        </script>




</body>
</html>