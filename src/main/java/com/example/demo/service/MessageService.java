package com.example.demo.service;

import com.example.demo.dto.MessageBundleDto;
import com.example.demo.dto.MessageDto;
import com.example.demo.dto.NotificationDto;
import com.example.demo.dto.ResponseDto;
import com.example.demo.entities.*;
import com.example.demo.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
    private final MessageRepository messageRepository;
    private final UserService userService;
    private final NotificationRepository notificationRepository;
    private final ResponseRepository responseRepository;
    private final SpecialistRepository specialistRepository;
    private final UserRepository userRepository;
    private final PostService postService;
    private final ResponseService responseService;

    public List<MessageBundleDto> getAll() {
        User user = userService.getUserFromSecurityContextHolder();
        return getAllMessagesByUser(user);
    }

    public List<MessageBundleDto> getAllMessagesByUser(User user) {
        if (user != null) {
            List<MessageBundleDto> list = getMessages(user);
            list.addAll(getResponses(user));
            list.sort(Comparator.comparing(MessageBundleDto::getLastMessageDateTime).reversed());
            log.info("Fetched {} messages for user {}", list.size(), user.getId());
            return list;
        }
        return Collections.emptyList();
    }

    private List<MessageBundleDto> getMessages(User user) {
        List<Message> allMessages = messageRepository.findAll();
        List<Message> shortList = new ArrayList<>();
        shortList.addAll(iAmReceiver(allMessages, user));
        shortList.addAll(iAmSender(allMessages, user));
        shortList.sort(Comparator.comparing(Message::getDateTime).reversed());
        Set<Long> uniqueUsers = uniqueIds(shortList, user);
        return filterBundle(shortList, uniqueUsers);

    }

    List<MessageBundleDto> filterBundle(List<Message> messages, Set<Long> filter) {
        List<MessageBundleDto> list = new ArrayList<>();
        for (Long l : filter)
            for (Message m : messages) {
                if (m.getSender().getId().equals(l)) {
                    list.add(MessageBundleDto.builder()
                            .id("msg" + "-" + m.getSender().getId())
                            .senderPhoto(m.getSender().getPhoto())
                            .senderName(m.getSender().getUserName())
                            .lastMessageText(m.getMessageText())
                            .lastMessageDateTime(formatDateTime(m.getDateTime()))
                            .build());
                    break;

                } else if (m.getReceiver().getId().equals(l)) {
                    list.add(MessageBundleDto.builder()
                            .id("msg" + "-" + m.getReceiver().getId())
                            .senderPhoto(m.getReceiver().getPhoto())
                            .senderName(m.getReceiver().getUserName())
                            .lastMessageText(m.getMessageText())
                            .lastMessageDateTime(formatDateTime(m.getDateTime()))
                            .build());
                    break;
                }

            }
        return list;
    }

    public Set<Long> uniqueIds(List<Message> messages, User user) {
        return messages.stream()
                .flatMap(m -> Stream.of(m.getReceiver().getId(), m.getSender().getId()))
                .filter(id -> !id.equals(user.getId()))
                .collect(Collectors.toSet());
    }

    public List<Message> iAmSender(List<Message> messages, User user) {
        return messages.stream()
                .filter(m -> m.getSender().getId().equals(user.getId()))
                .toList();
    }

    public List<Message> iAmReceiver(List<Message> messages, User user) {
        return messages.stream()
                .filter(m -> m.getReceiver().getId().equals(user.getId()))
                .toList();
    }

    public String formatDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd HH:mm");
        return dateTime.format(formatter);
    }


    public List<NotificationDto> getAllNotifications() {
        User user = userService.getUserFromSecurityContextHolder();
        if (user != null) {
            List<Notification> list = getAllNotificationsByUser(user);
            return list.stream().map(this::makeDtoFromNotification).toList();
        }
        return Collections.emptyList();
    }

    public List<Notification> getAllNotificationsByUser(User user) {
        if (user != null) {
            return notificationRepository.findAllByUser(user);
        }
        return Collections.emptyList();
    }

    private NotificationDto makeDtoFromNotification(Notification n) {
        return NotificationDto.builder()
                .id(n.getId())
                .userId(n.getUser().getId())
                .notificationText(n.getNotificationText())
                .notificationDate(n.getNotificationDate())
                .build();
    }

    private List<MessageBundleDto> getResponses(User user) {
        List<Response> allResponses = responseRepository.findAll();
        if (user.getUserType().equalsIgnoreCase("customer")) {
            List<Post> posts = postService.getAllCustomerPosts(user.getId());
            List<Response> responses = getCustomerResponses(allResponses, posts);
            Set<String> filter = uniqueConversations(responses);
            return responseService.customerResponses(responses, filter);
        } else {
            Set<String> filter = uniqueConversationsBySpecialist(allResponses, user);
            List<Response> responses = getSpecialistResponses(allResponses, filter);
            return responseService.specialistResponses(responses, filter);
        }
    }


    private List<Response> getCustomerResponses(List<Response> responses, List<Post> posts) {
        List<Response> list = new ArrayList<>();
        for (Post p : posts) {
            for (Response r : responses) {
                if (r.getPost().equals(p)) list.add(r);
            }
        }
        return list;
    }

    private Set<String> uniqueConversations(List<Response> responses) {
        return responses.stream()
                .map(Response::getConversationId)
                .collect(Collectors.toSet());
    }

    private Set<String> uniqueConversationsBySpecialist(List<Response> responses, User user) {
        var specialist = specialistRepository.findByUser(user);
        Set<String> set = new HashSet<>();
        if (specialist.isPresent()) {
            for (Response r : responses) {
                if (r.getSpecialist() != null && (r.getSpecialist().getId().equals(specialist.get().getId()))) {
                    set.add(r.getConversationId());
                }
            }
        }
        return set;
    }

    private List<Response> getSpecialistResponses(List<Response> responses, Set<String> filter) {
        List<Response> list = new ArrayList<>();
        for (String s : filter) {
            for (Response r : responses) {
                if (s.equalsIgnoreCase(r.getConversationId())) list.add(r);
            }
        }
        return list;
    }

    public List<ResponseDto> viewMessages(String id) {
        User user = userService.getUserFromSecurityContextHolder();
        if (user == null) return Collections.emptyList();
        Long value = Long.parseLong(postService.extractStringAfterDash(id));
        List<ResponseDto> list = new ArrayList<>();
        List<Message> messages = messageRepository.findBySenderIdAndReceiverId(value, user.getId());
        messages.addAll(messageRepository.findBySenderIdAndReceiverId(user.getId(), value));
        messages.sort(Comparator.comparing(Message::getDateTime));
        for (Message m : messages) {
            String s = (user.getId().equals(m.getSender().getId())) ? "author" : "reader";

            list.add(ResponseDto.builder()
                    .response(m.getMessageText())
                    .viewer(s)
                    .dateTime(formatDateTime(m.getDateTime()))
                    .build());
        }
        return list;
    }

    public List<ResponseDto> findNewMessages(String localDateTime, String conversationId) {
        User user = userService.getUserFromSecurityContextHolder();
        if (user == null) return Collections.emptyList();

        Long value = Long.parseLong(postService.extractStringAfterDash(conversationId));
        List<ResponseDto> list = new ArrayList<>();
        List<Message> messages = messageRepository.findBySenderIdAndReceiverId(value, user.getId());


        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSX");
        LocalDateTime ldt = LocalDateTime.parse(localDateTime, formatter);

        for (Message m : messages) {
            ZoneId zoneId = ZoneId.of("Asia/Bishkek");
            ZonedDateTime responseDateTime = m.getDateTime().atZone(zoneId);
            ZonedDateTime requestDateTime = ldt.atZone(zoneId).plusHours(6);
            if (requestDateTime.isBefore(responseDateTime)) {
                list.add(ResponseDto.builder()
                        .response(m.getMessageText())
                        .viewer("reader")
                        .dateTime(formatDateTime(m.getDateTime()))
                        .build());
            }
        }
        return list;
    }

    public HttpStatus saveMessage(String msgId, MessageDto responseDto) {
        User user = userService.getUserFromSecurityContextHolder();
        Long receiverId = Long.parseLong(postService.extractStringAfterDash(msgId));
        var user2 = userRepository.findById(receiverId);
        if (user2.isPresent()) {
            Message m = Message.builder()
                    .sender(user)
                    .receiver(user2.get())
                    .messageText(responseDto.getResponse())
                    .dateTime(LocalDateTime.now())
                    .build();
            saveANewMessage(m);
        } else {
            return HttpStatus.NOT_FOUND;
        }
        return HttpStatus.OK;
    }

    public HttpStatus saveNewMessage(MessageDto messageDto) {
        Message m = makeMessageFromDto(messageDto);
        if (m == null) {
            return HttpStatus.NOT_FOUND;
        }
        saveANewMessage(m);
        return HttpStatus.OK;

    }

    private Message makeMessageFromDto(MessageDto messageDto) {
        User sender = userService.getUserFromSecurityContextHolder();
        if (sender != null) {
            User receiver = null;
            try {
                Long id = Long.parseLong(messageDto.getViewer());
                var user = userRepository.findById(id);
                if (user.isPresent()) receiver = user.get();
            } catch (NumberFormatException e) {
                var user = userRepository.findAllByUserNameContainingIgnoreCase(messageDto.getViewer());
                if (user.size() == 1) {
                    receiver = user.get(0);
                } else {
                    return null;
                }
            }
            return Message.builder()
                    .sender(sender)
                    .receiver(receiver)
                    .messageText(messageDto.getResponse())
                    .dateTime(LocalDateTime.now())
                    .build();
        }
        return null;
    }

    public Message saveANewMessage(Message m) {
        return messageRepository.save(m);
    }

    @Transactional
    public void deleteNotification(long notificationId, long userId) {
        notificationRepository.deleteNotificationByIdAndUserId(notificationId, userId);
    }

    @Transactional
    public void deleteMessage(long messageId, long userId) {
        var m = messageRepository.findById(messageId);
        if(m.isPresent()) {
            deleteAMessage(m.get());
        }
    }
    public void deleteAMessage(Message m) {
        messageRepository.delete(m);
    }
    public Message findAMessage(Long id) {
        var m = messageRepository.findById(id);
        if(m.isEmpty()) return null;
        else return m.get();
    }
}

