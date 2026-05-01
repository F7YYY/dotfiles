/* Open Hardware Monitor helpers */

var OpenHardware = {
    fetchData: function() {
        var sensors = [];
        function enumerateData(prefix, data) {
            data.FullName = prefix + data.Text;
            sensors.push(data);
            if (data.Children) {
                if (data.id > 1) {
                    prefix = data.FullName + "/";
                }
                for (const child of data.Children) {
                    enumerateData(prefix, child);
                }
            }
            return sensors;
        }
        return $SD.readJson("http://localhost:8085/data.json")
            .then((data) => enumerateData("", data));
    }
};