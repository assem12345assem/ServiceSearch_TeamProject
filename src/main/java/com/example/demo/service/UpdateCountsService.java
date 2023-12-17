package com.example.demo.service;

import com.example.demo.entities.SubscriptionsOnTariffs;
import com.example.demo.entities.Tariff;
import com.example.demo.entities.UpdateCounts;
import com.example.demo.entities.User;
import com.example.demo.repository.SubscriptionsOnTariffsRepository;
import com.example.demo.repository.TariffRepository;
import com.example.demo.repository.UpdateCountsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UpdateCountsService {
    private final UpdateCountsRepository repository;
    private final SubscriptionsOnTariffsRepository subscriptionsOnTariffsRepository;
    private final TariffRepository tariffRepository;

    public void deleteCount(long id) {
        repository.deleteById((int) id);
    }

    public boolean saveUpdate(User user) {
        if(availableUpsCount(user) > 0) {
            repository.save(UpdateCounts.builder()
                    .userId(user.getId())
                    .count(1)
                    .updateTime(Timestamp.valueOf(LocalDateTime.now()))
                    .build());
            return true;
        }
        return false;
    }

    public boolean hasThirtyDaysPassed(Timestamp timestamp) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_MONTH, -30);

        Timestamp thirtyDaysAgoTimestamp = new Timestamp(calendar.getTime().getTime());
        return timestamp.before(thirtyDaysAgoTimestamp);
    }

    private boolean hasOneDayPassed(Timestamp timestamp) {
        LocalDateTime actual = timestamp.toLocalDateTime();
        LocalDateTime oneDayAgo = LocalDateTime.now().minusHours(24L);
        return actual.isBefore(oneDayAgo);
    }

    public int availableUpsCount(User user) {
        List<UpdateCounts> userUpdates = repository.findAllByUserId(user.getId());
        SubscriptionsOnTariffs s = getRelevantSubscription(user);
        if (s.getTariff().getId() == 1L) {
            List<UpdateCounts> newList = pruneOldUpdateCountsFreeTariff(userUpdates);
            return 5 - newList.size();
        } else {
            List<UpdateCounts> newList = pruneOldUpdateCountsPaidTariff(userUpdates);
            return 2 - newList.size();
        }
    }

    private SubscriptionsOnTariffs getRelevantSubscription(User user) {
        List<SubscriptionsOnTariffs> list = subscriptionsOnTariffsRepository.findAllByUserId(user.getId());
        if (list.isEmpty()) {
            return subscriptionsOnTariffsRepository.save(SubscriptionsOnTariffs.builder()
                    .user(user)
                    .tariff(getFreeTariff())
                    .startPeriodTime(LocalDateTime.now())
                    .endPeriodTime(LocalDateTime.of(3000, 12, 31, 0, 0))
                    .build());

        } else {
            return findValidTariff(list);
        }
    }

    private List<UpdateCounts> pruneOldUpdateCountsPaidTariff(List<UpdateCounts> list) {
        for (UpdateCounts u : list) {
            if (hasOneDayPassed(u.getUpdateTime())) {
                deleteCount(u.getId());
                list.remove(u);
            }
        }
        return list;
    }

    private List<UpdateCounts> pruneOldUpdateCountsFreeTariff(List<UpdateCounts> list) {
        for (UpdateCounts u : list) {
            if (hasThirtyDaysPassed(u.getUpdateTime())) {
                deleteCount(u.getId());
                list.remove(u);
            }
        }
        return list;
    }

    private SubscriptionsOnTariffs findValidTariff(List<SubscriptionsOnTariffs> list) {
        LocalDateTime now = LocalDateTime.now();
        for (SubscriptionsOnTariffs s : list) {
            if (s.getTariff().getId() != 1L && s.getEndPeriodTime().isBefore(now)) {
                subscriptionsOnTariffsRepository.delete(s);
                list.remove(s);
            }
        }
        if (list.size() != 1) {
            for (SubscriptionsOnTariffs s : list) {
                if (s.getTariff().getId() != 1L) {
                    return s;
                }
            }
        }
        return list.get(0);
    }

    private Tariff getFreeTariff() {
        var maybeTariff = tariffRepository.findByTariffName("free");
        if (maybeTariff.isPresent()) return maybeTariff.get();
        return null;
    }
}
