//
//  LexiconEntry.swift
//  VocabApp
//
//  Created by AI Assistant on 25/10/2025.
//  Shared vocabulary lexicon entry model
//

import Foundation

/// Model đại diện cho một entry trong từ điển
struct LexiconEntry {
    let en: String      // Tiếng Anh
    let vi: String      // Tiếng Việt
    let ipa: String     // Phiên âm IPA
    let synonyms: [String]  // Các từ đồng nghĩa/tương tự
}

/// Helper class để quản lý lexicon entries
final class LexiconManager {
    
    // MARK: - Shared Entries Database
    static let entries: [LexiconEntry] = [
        // Personal items
        LexiconEntry(en: "phone", vi: "điện thoại", ipa: "/fəʊn/", synonyms: ["phone","cell phone","cellphone","cellular telephone","mobile phone","smartphone","iphone","android phone"]),
        LexiconEntry(en: "charger", vi: "sạc", ipa: "/ˈtʃɑːdʒə(r)/", synonyms: ["charger","phone charger","power adapter","ac adapter","power brick"]),
        LexiconEntry(en: "earphones", vi: "tai nghe", ipa: "/ˈɪəfəʊnz/", synonyms: ["earphones","earbuds","headphones","headset","airpods"]),
        LexiconEntry(en: "watch", vi: "đồng hồ đeo tay", ipa: "/wɒtʃ/", synonyms: ["watch","wristwatch"]),
        LexiconEntry(en: "glasses", vi: "kính mắt", ipa: "/ˈɡlɑːsɪz/", synonyms: ["glasses","spectacles"]),
        LexiconEntry(en: "sunglasses", vi: "kính râm", ipa: "/ˈsʌnˌɡlɑːsɪz/", synonyms: ["sunglasses","shades"]),
        LexiconEntry(en: "wallet", vi: "ví", ipa: "/ˈwɒlɪt/", synonyms: ["wallet","billfold"]),
        LexiconEntry(en: "key", vi: "chìa khóa", ipa: "/kiː/", synonyms: ["key","keys","keychain"]),
        LexiconEntry(en: "lighter", vi: "bật lửa", ipa: "/ˈlaɪtə(r)/", synonyms: ["lighter","cigarette lighter"]),
        LexiconEntry(en: "mask", vi: "khẩu trang", ipa: "/mɑːsk/", synonyms: ["mask","face mask","medical mask","surgical mask"]),
        LexiconEntry(en: "umbrella", vi: "ô", ipa: "/ʌmˈbrelə/", synonyms: ["umbrella","parasol","brolly"]),

        // Clothing & accessories
        LexiconEntry(en: "jacket", vi: "áo khoác", ipa: "/ˈdʒækɪt/", synonyms: ["jacket","coat"]),
        LexiconEntry(en: "t-shirt", vi: "áo thun", ipa: "/ˈtiː ʃɜːt/", synonyms: ["t-shirt","tee shirt","shirt"]),
        LexiconEntry(en: "jeans", vi: "quần jeans", ipa: "/dʒiːnz/", synonyms: ["jeans","denim"]),
        LexiconEntry(en: "hat", vi: "mũ", ipa: "/hæt/", synonyms: ["hat","cap","baseball cap"]),
        LexiconEntry(en: "shoes", vi: "giày", ipa: "/ʃuːz/", synonyms: ["shoes","sneakers","trainers"]),
        LexiconEntry(en: "sandals", vi: "dép", ipa: "/ˈsændlz/", synonyms: ["sandals","flip-flops","slippers"]),
        LexiconEntry(en: "socks", vi: "tất", ipa: "/sɒks/", synonyms: ["socks"]),
        LexiconEntry(en: "belt", vi: "thắt lưng", ipa: "/belt/", synonyms: ["belt"]),
        LexiconEntry(en: "handbag", vi: "túi xách", ipa: "/ˈhændbæɡ/", synonyms: ["handbag","purse","shoulder bag"]),
        LexiconEntry(en: "backpack", vi: "ba lô", ipa: "/ˈbækpæk/", synonyms: ["backpack","rucksack","bagpack"]),

        // Hygiene / medical
        LexiconEntry(en: "toothbrush", vi: "bàn chải đánh răng", ipa: "/ˈtuːθbrʌʃ/", synonyms: ["toothbrush"]),
        LexiconEntry(en: "toothpaste", vi: "kem đánh răng", ipa: "/ˈtuːθpeɪst/", synonyms: ["toothpaste"]),
        LexiconEntry(en: "comb", vi: "lược", ipa: "/kəʊm/", synonyms: ["comb","hair comb"]),
        LexiconEntry(en: "razor", vi: "dao cạo", ipa: "/ˈreɪzə(r)/", synonyms: ["razor","shaver"]),
        LexiconEntry(en: "towel", vi: "khăn tắm", ipa: "/ˈtaʊəl/", synonyms: ["towel"]),
        LexiconEntry(en: "cotton pads", vi: "bông tẩy trang", ipa: "/ˈkɒtn pædz/", synonyms: ["cotton pads","cotton rounds"]),

        // Kitchen & dining
        LexiconEntry(en: "bowl", vi: "chén/tô", ipa: "/bəʊl/", synonyms: ["bowl"]),
        LexiconEntry(en: "plate", vi: "dĩa", ipa: "/pleɪt/", synonyms: ["plate","dish"]),
        LexiconEntry(en: "spoon", vi: "thìa", ipa: "/spuːn/", synonyms: ["spoon"]),
        LexiconEntry(en: "chopsticks", vi: "đũa", ipa: "/ˈtʃɒp.stɪks/", synonyms: ["chopsticks"]),
        LexiconEntry(en: "cup", vi: "ly/cốc", ipa: "/kʌp/", synonyms: ["cup","mug"]),
        LexiconEntry(en: "bottle", vi: "bình/chai nước", ipa: "/ˈbɒtl/", synonyms: ["bottle","water bottle"]),
        LexiconEntry(en: "pot", vi: "nồi", ipa: "/pɒt/", synonyms: ["pot","saucepan"]),
        LexiconEntry(en: "pan", vi: "chảo", ipa: "/pæn/", synonyms: ["pan","frying pan","skillet"]),
        LexiconEntry(en: "cutting board", vi: "thớt", ipa: "/ˈkʌtɪŋ bɔːd/", synonyms: ["cutting board","chopping board"]),
        LexiconEntry(en: "kitchen knife", vi: "dao bếp", ipa: "/naɪf/", synonyms: ["knife","kitchen knife","chef's knife"]),
        LexiconEntry(en: "food container", vi: "hộp đựng thực phẩm", ipa: "/kənˈteɪnə(r)/", synonyms: ["food container","lunch box","tupperware"]),

        // Home & furniture
        LexiconEntry(en: "doorknob", vi: "tay nắm cửa", ipa: "/ˈdɔːnɒb/", synonyms: ["doorknob","door handle","door knob"]),
        LexiconEntry(en: "remote control", vi: "điều khiển", ipa: "/rɪˈməʊt kənˈtrəʊl/", synonyms: ["remote","remote control","tv remote"]),
        LexiconEntry(en: "light switch", vi: "công tắc đèn", ipa: "/laɪt swɪtʃ/", synonyms: ["light switch","switch"]),
        LexiconEntry(en: "table", vi: "cái bàn", ipa: "/ˈteɪbl/", synonyms: ["table","desk"]),
        LexiconEntry(en: "chair", vi: "cái ghế", ipa: "/tʃeə(r)/", synonyms: ["chair","armchair"]),
        LexiconEntry(en: "pillow", vi: "gối", ipa: "/ˈpɪləʊ/", synonyms: ["pillow","cushion"]),
        LexiconEntry(en: "blanket", vi: "chăn", ipa: "/ˈblæŋkɪt/", synonyms: ["blanket"]),
        LexiconEntry(en: "rug", vi: "thảm", ipa: "/rʌɡ/", synonyms: ["rug","carpet"]),
        LexiconEntry(en: "sink", vi: "bồn rửa", ipa: "/sɪŋk/", synonyms: ["sink"]),
        LexiconEntry(en: "faucet", vi: "vòi nước", ipa: "/ˈfɔːsɪt/", synonyms: ["faucet","tap"]),

        // Electronics & work
        LexiconEntry(en: "laptop", vi: "máy tính xách tay", ipa: "/ˈlæptɒp/", synonyms: ["laptop","notebook"]),
        LexiconEntry(en: "keyboard", vi: "bàn phím", ipa: "/ˈkiːbɔːd/", synonyms: ["keyboard"]),
        LexiconEntry(en: "mouse", vi: "chuột", ipa: "/maʊs/", synonyms: ["mouse","computer mouse"]),
        LexiconEntry(en: "printer", vi: "máy in", ipa: "/ˈprɪntə(r)/", synonyms: ["printer"]),
        LexiconEntry(en: "camera", vi: "máy ảnh", ipa: "/ˈkæmərə/", synonyms: ["camera"]),
        LexiconEntry(en: "tablet", vi: "máy tính bảng", ipa: "/ˈtæblət/", synonyms: ["tablet","ipad","android tablet","galaxy tab"]),
        LexiconEntry(en: "monitor", vi: "màn hình", ipa: "/ˈmɒnɪtə(r)/", synonyms: ["monitor","display","screen"]),
        LexiconEntry(en: "hard drive", vi: "ổ cứng di động", ipa: "/hɑːd draɪv/", synonyms: ["hard drive","external drive"]),
        LexiconEntry(en: "usb flash drive", vi: "usb", ipa: "/juː es biː/", synonyms: ["usb","flash drive","thumb drive"]),
        LexiconEntry(en: "notebook", vi: "sổ tay", ipa: "/ˈnəʊtbʊk/", synonyms: ["notebook","journal"]),
        LexiconEntry(en: "pen", vi: "bút", ipa: "/pen/", synonyms: ["pen","ballpoint pen","gel pen","rollerball pen","marker","highlighter","sharpie"]),
        LexiconEntry(en: "pencil", vi: "bút chì", ipa: "/ˈpensl/", synonyms: ["pencil","mechanical pencil"]),
        LexiconEntry(en: "ruler", vi: "thước kẻ", ipa: "/ˈruːlə(r)/", synonyms: ["ruler","scale"]),
        LexiconEntry(en: "eraser", vi: "tẩy", ipa: "/ɪˈreɪzə(r)/", synonyms: ["eraser","rubber"]),
        LexiconEntry(en: "stapler", vi: "bấm ghim", ipa: "/ˈsteɪplə(r)/", synonyms: ["stapler"]),

        // Toys & baby
        LexiconEntry(en: "teddy bear", vi: "gấu bông", ipa: "/ˈtedi beə(r)/", synonyms: ["teddy","teddy bear"]),
        LexiconEntry(en: "toy car", vi: "xe đồ chơi", ipa: "/tɔɪ kɑː(r)/", synonyms: ["toy car"]),
        LexiconEntry(en: "ball", vi: "bóng", ipa: "/bɔːl/", synonyms: ["ball","football","soccer ball"]),
        LexiconEntry(en: "building blocks", vi: "khối xếp hình", ipa: "/ˈbɪldɪŋ blɒks/", synonyms: ["blocks","lego","building blocks"]),
        LexiconEntry(en: "baby bottle", vi: "bình sữa", ipa: "/ˈbeɪbi ˈbɒtl/", synonyms: ["baby bottle","feeding bottle"]),
        LexiconEntry(en: "pacifier", vi: "núm vú giả", ipa: "/ˈpæsɪfaɪə(r)/", synonyms: ["pacifier","dummy"]),

        // Tools
        LexiconEntry(en: "hammer", vi: "búa", ipa: "/ˈhæmə(r)/", synonyms: ["hammer"]),
        LexiconEntry(en: "screwdriver", vi: "tua vít", ipa: "/ˈskruːˌdraɪvə(r)/", synonyms: ["screwdriver"]),
        LexiconEntry(en: "pliers", vi: "kìm", ipa: "/ˈplaɪəz/", synonyms: ["pliers"]),
        LexiconEntry(en: "drill", vi: "khoan cầm tay", ipa: "/drɪl/", synonyms: ["drill","hand drill"]),
        LexiconEntry(en: "tape measure", vi: "thước dây", ipa: "/teɪp ˈmeʒə(r)/", synonyms: ["tape measure","measuring tape"]),
        LexiconEntry(en: "scissors", vi: "kéo", ipa: "/ˈsɪzəz/", synonyms: ["scissors"]),
        LexiconEntry(en: "voltage tester", vi: "bút thử điện", ipa: "/ˈvəʊltɪdʒ ˈtestə(r)/", synonyms: ["voltage tester","test pen"]),

        // Transport / travel
        LexiconEntry(en: "handlebar", vi: "tay lái xe máy", ipa: "/ˈhændlbɑː(r)/", synonyms: ["handlebar","motorbike handlebar"]),
        LexiconEntry(en: "gear lever", vi: "cần số", ipa: "/ɡɪə ˈliːvə(r)/", synonyms: ["gear lever","gear stick","shifter"]),
        LexiconEntry(en: "car seat", vi: "ghế ô tô", ipa: "/kɑː siːt/", synonyms: ["car seat"]),
        LexiconEntry(en: "helmet", vi: "mũ bảo hiểm", ipa: "/ˈhelmɪt/", synonyms: ["helmet"]),
        LexiconEntry(en: "suitcase", vi: "vali", ipa: "/ˈsuːtkeɪs/", synonyms: ["suitcase","luggage"]),
        LexiconEntry(en: "travel backpack", vi: "ba lô du lịch", ipa: "/ˈbækpæk/", synonyms: ["travel backpack","backpack"]),

        // Groceries & food packs
        LexiconEntry(en: "paper bag", vi: "túi giấy", ipa: "/ˈpeɪpə bæɡ/", synonyms: ["paper bag"]),
        LexiconEntry(en: "plastic bag", vi: "túi nilon", ipa: "/ˈplæstɪk bæɡ/", synonyms: ["plastic bag"]),
        LexiconEntry(en: "cardboard box", vi: "hộp giấy", ipa: "/ˈkɑːdbɔːd bɒks/", synonyms: ["cardboard box","box"]),
        LexiconEntry(en: "plastic container", vi: "hộp nhựa", ipa: "/ˈplæstɪk kənˈteɪnə(r)/", synonyms: ["plastic container"]),
        LexiconEntry(en: "snack pack", vi: "gói snack", ipa: "/snæk pæk/", synonyms: ["snack","chips","crisps"]),
        LexiconEntry(en: "milk carton", vi: "hộp sữa", ipa: "/mɪlk ˈkɑːtn/", synonyms: ["milk carton","milk box"]),
        LexiconEntry(en: "banana", vi: "chuối", ipa: "/bəˈnɑːnə/", synonyms: ["banana"]),
        LexiconEntry(en: "apple", vi: "táo", ipa: "/ˈæpl/", synonyms: ["apple"]),
        LexiconEntry(en: "vegetables", vi: "rau củ", ipa: "/ˈvedʒtəblz/", synonyms: ["vegetables","veggies"]),
        LexiconEntry(en: "spice packet", vi: "gói gia vị", ipa: "/spaɪs ˈpækɪt/", synonyms: ["spice","seasoning packet"]),

        // Sports & leisure
        LexiconEntry(en: "football", vi: "bóng đá", ipa: "/ˈfʊtbɔːl/", synonyms: ["football","soccer ball"]),
        LexiconEntry(en: "badminton racket", vi: "vợt cầu lông", ipa: "/ˈbædmɪntən ˈrækɪt/", synonyms: ["badminton racket"]),
        LexiconEntry(en: "tennis racket", vi: "vợt tennis", ipa: "/ˈtenɪs ˈrækɪt/", synonyms: ["tennis racket"]),
        LexiconEntry(en: "trainers", vi: "giày thể thao", ipa: "/ˈtreɪnəz/", synonyms: ["sneakers","trainers","running shoes"]),
        LexiconEntry(en: "yoga mat", vi: "thảm yoga", ipa: "/ˈjəʊɡə mæt/", synonyms: ["yoga mat"]),
        LexiconEntry(en: "sports bottle", vi: "bình nước thể thao", ipa: "/bɒtl/", synonyms: ["sports bottle","water bottle"]),

        // Beauty
        LexiconEntry(en: "lipstick", vi: "son", ipa: "/ˈlɪpstɪk/", synonyms: ["lipstick"]),
        LexiconEntry(en: "powder", vi: "phấn", ipa: "/ˈpaʊdə(r)/", synonyms: ["face powder","powder"]),
        LexiconEntry(en: "hand mirror", vi: "gương cầm tay", ipa: "/hænd ˈmɪrə(r)/", synonyms: ["hand mirror","mirror"]),
        LexiconEntry(en: "spray bottle", vi: "bình xịt", ipa: "/spreɪ ˈbɒtl/", synonyms: ["spray bottle","spray"]),
        LexiconEntry(en: "hair dryer", vi: "máy sấy tóc", ipa: "/heə ˈdraɪə(r)/", synonyms: ["hair dryer"]),
        LexiconEntry(en: "nail clipper", vi: "máy cắt móng", ipa: "/neɪl ˈklɪpə(r)/", synonyms: ["nail clipper","nail cutter"]),

        // Outdoor / public
        LexiconEntry(en: "park bench", vi: "ghế công viên", ipa: "/bentʃ/", synonyms: ["bench","park bench"]),
        LexiconEntry(en: "trash bin", vi: "thùng rác", ipa: "/træʃ bɪn/", synonyms: ["trash can","garbage can","bin"]),
        LexiconEntry(en: "handrail", vi: "thanh vịn", ipa: "/ˈhændreɪl/", synonyms: ["handrail"]),
        LexiconEntry(en: "railing", vi: "lan can", ipa: "/ˈreɪlɪŋ/", synonyms: ["railing","banister"]),
        LexiconEntry(en: "sign", vi: "biển báo", ipa: "/saɪn/", synonyms: ["sign","road sign"]),
        LexiconEntry(en: "gate", vi: "cổng", ipa: "/ɡeɪt/", synonyms: ["gate"]),

        // Easy-to-forget touches
        LexiconEntry(en: "pill box", vi: "hộp thuốc", ipa: "/pɪl bɒks/", synonyms: ["pill box","medicine box"]),
        LexiconEntry(en: "tv remote", vi: "điều khiển TV", ipa: "/rɪˈməʊt/", synonyms: ["tv remote","remote"]),
        LexiconEntry(en: "car key fob", vi: "remote xe hơi", ipa: "/fɒb/", synonyms: ["key fob","car remote"]),
        LexiconEntry(en: "ticket", vi: "vé", ipa: "/ˈtɪkɪt/", synonyms: ["ticket"]),
        LexiconEntry(en: "documents", vi: "giấy tờ", ipa: "/ˈdɒkjʊmənts/", synonyms: ["documents","paperwork"]),
        LexiconEntry(en: "tape", vi: "băng keo", ipa: "/teɪp/", synonyms: ["tape","adhesive tape"]),
        LexiconEntry(en: "charging cable", vi: "cáp sạc", ipa: "/ˈtʃɑːdʒɪŋ ˈkeɪbl/", synonyms: ["charging cable","usb cable","lightning cable"])
    ]
    
    // MARK: - Lookup Methods
    
    static func lookup(rawLabel: String) -> LexiconEntry? {
        let key = normalize(rawLabel)
        if let direct = directMap[key] { return direct }

        // tách theo dấu phẩy/gạch dưới/khoảng trắng để thử từng token
        let simplified = key.replacingOccurrences(of: ",", with: " ").replacingOccurrences(of: "_", with: " ")
        for token in simplified.split(separator: " ") {
            let t = normalize(String(token))
            if let hit = directMap[t] { return hit }
        }

        // duyệt synonyms
        for e in entries {
            if e.synonyms.contains(key) { return e }
        }
        return nil
    }

    static func normalize(_ s: String) -> String {
        let low = s.lowercased()
        let trimmed = low.trimmingCharacters(in: .whitespacesAndNewlines)
        // bỏ 's' số nhiều đơn giản
        if trimmed.hasSuffix("s"), trimmed.count > 3 {
            return String(trimmed.dropLast())
        }
        return trimmed
    }

    private static let directMap: [String: LexiconEntry] = {
        var m: [String: LexiconEntry] = [:]
        for e in entries {
            m[normalize(e.en)] = e
            for s in e.synonyms { m[normalize(s)] = e }
        }
        return m
    }()
}


